import 'dart:convert';
import 'package:android_id/android_id.dart';
import 'package:client_information/client_information.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/tools/service.dart';

class ConfigController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;

  var configData = "".obs;
  var moduleList = <Module>[].obs;
  var isNeedUpdate = false.obs;

  @override
  void onInit() {
    super.onInit();
    // getConfigData();
    // getModuleData();
    syncAppsReady();
  }

  syncAppsReady() async {
    if (await checkAppsPermission('STORAGE')) {
      if (await checkAppsPermission('INSTALL PACKAGES')) {
        if (await checkAppsPermission('EXTERNAL STORAGE')) {
          await getModuleData();
        } else {
          syncAppsReady();
        }
      } else {
        syncAppsReady();
      }
    } else {
      syncAppsReady();
    }
  }

  Future<bool> checkAppsPermission(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (type == 'STORAGE') {
      status = await Permission.storage.request();
    } else if (type == 'INSTALL PACKAGES') {
      if (sdkInt >= 26) {
        status = await Permission.requestInstallPackages.request();
      } else {
        return true;
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (sdkInt >= 30) {
        status = await Permission.manageExternalStorage.request();
      } else {
        return true;
      }
    }
    return status == PermissionStatus.granted;
  }

  Future<String> getConfigData() async {
    isLoading(true);
    isError(false);
    try {
      final result = await ApiClient().getData("/config?app=quiz");
      var data = jsonDecode(result.toString());
      configData.value = data[0]["Value"].toString();

      await getModuleData();

      // isLoading(false);
      // isError(false);
      // Get.offAndToNamed(RouteName.homepage);
    } catch(e) {
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
    }
    return configData.value;
  }

  getModuleData() async {
    isLoading(true);
    isError(false);

    try {
      final result = await ApiClient().getData("/module?sales_id=00AC1A0103");
      var data = jsonDecode(result.toString());
      data.map((item) {
        moduleList.add(Module.from(item));
      }).toList();

      var appModuleBox = await Hive.openBox<Module>('appModuleBox');
      if(appModuleBox.length > 0) {
        for(int i=0; i<appModuleBox.length; i++) {
          if(moduleList[i].version != appModuleBox.getAt(i)?.version) {
            isNeedUpdate(true);
            break;
          }
        }
      } else {
        for(int i=0; i<moduleList.length; i++) {
          await appModuleBox.add(moduleList[i]);
        }
      }

      isLoading(false);
      isError(false);

      if(isNeedUpdate.value) {
        print("need update");
      } else {
        Get.offAndToNamed(RouteName.homepage);
      }

    } catch(e) {
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
    }


  }

}