import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/common/route_config.dart';
import 'package:sfa_tools/models/module.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/dialog.dart';
import 'package:sfa_tools/widgets/textview.dart';

class SplashscreenController extends GetxController with StateMixin {
  // var isError = false.obs;
  var errorMessage = "".obs;

  var appVersion = "".obs;
  var configData = "".obs;
  var moduleList = <Module>[].obs;
  var isNeedUpdate = false.obs;

  //parameter data
  var salesIdParams = "".obs;
  var customerIdParams = "".obs;
  var isCheckInParams = "".obs;

  final txtServerIPController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    syncAppsReady();
  }

  openErrorDialog() {
    appsDialog(
      type: "app_error",
      title:  Obx(() => TextView(
        headings: "H4",
        text: errorMessage.value,
        textAlign: TextAlign.center,
        ),
      ),
      leftBtnMsg: "Ok",
      isAnimated: true,
      leftActionClick: () {
        Get.back();
      }
    );
  }

  syncAppsReady() async {
    if (await checkAppsPermission('STORAGE')) {
      if (await checkAppsPermission('EXTERNAL STORAGE')) {
        await checkUpdate();
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
      if(sdkInt < 33) {
        status = await Permission.storage.request();
      } else {
        //if you need the access for both photos and videos, 
        //you can use either Permission.photos or Permission.video, you don’t need both of them, 
        //because in Granular Media the access is granted for both media types.
        status = await Permission.photos.request();
      }
    } else if (type == 'INSTALLS PACKAGES') {
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

    if (status != PermissionStatus.granted) {
      if (status == PermissionStatus.denied) {
        return status == PermissionStatus.granted;
      } else if (status == PermissionStatus.permanentlyDenied) {
        status = await Permission.storage.status;

        while (status != PermissionStatus.granted) {
          await openAppSettings();
          status = await Permission.storage.status;
        }
        return status == PermissionStatus.granted;
      }
    }
    return status == PermissionStatus.granted;
  }

  checkUpdate() async {
    change(null, status: RxStatus.loading());

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String currentVersion = packageInfo.version;
    appVersion.value = currentVersion;

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if(isConnected) {
      try {
        final encryptedParam = await Utils.encryptData(appName);

        final result = await ApiClient().getData(urlAPI, "/version?app=$encryptedParam");
        var data = jsonDecode(result.toString());

        String latestVersion = data[0]["Value"];
        int currentVersionConverted = Utils().convertVersionNumber(currentVersion);
        int latestVersionConverted = Utils().convertVersionNumber(latestVersion);

        if(latestVersionConverted > currentVersionConverted) {
          change(null, status: RxStatus.success());

          appsDialog(
            type: "app_info",
            title: const TextView(
              headings: "H4",
              text: "Terdapat versi aplikasi yang lebih baru.\n\nIkuti langkah-langkah berikut :\n1. Tekan OK untuk kembali ke aplikasi SFA.\n2. Tekan menu Pengaturan.\n3. Tekan tombol Unduh Aplikasi SFA Tools.\n4. Tunggu hingga proses update selesai.",
              textAlign: TextAlign.start,
            ),
            leftBtnMsg: "ok",
            isAnimated: true,
            leftActionClick: () {
              Get.back();
              SystemNavigator.pop();
            }
          );
        } else {
          await getParameterData();
          getModuleData();
        }
      } catch(e) {
        errorMessage.value = e.toString();
        openErrorDialog();
        change(null, status: RxStatus.error(errorMessage.value));
      }
    } else {
      var moduleBox = await Hive.openBox<Module>('moduleBox');
      if(moduleBox.length > 0) {
        moduleList.clear();
        moduleList.addAll(moduleBox.values);
        
        await getParameterData();

        change(null, status: RxStatus.success());
        Get.offAndToNamed(RouteName.homepage);
      } else {
        errorMessage(Message.errorConnection);
        openErrorDialog();
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  getParameterData() async {
    //SalesID;CustID;LocCheckIn
    String parameter = await Utils().readParameter();
    if(parameter != "") {
      var arrParameter = parameter.split(';');
      for(int i=0; i<arrParameter.length; i++) {
        if(i == 0) {
          salesIdParams.value = arrParameter[i];
        } else if(i == 1) {
          customerIdParams.value = arrParameter[i];
        } else {
          isCheckInParams.value = arrParameter[2];
        }
      }
    }
  }

  getModuleData() async {
    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if(isConnected) {
      moduleList.clear();

      try {
        final encryptedParam = await Utils.encryptData(salesIdParams.value);

        final result = await ApiClient().getData(urlAPI, "/module?sales_id=$encryptedParam");
        var data = jsonDecode(result.toString());
        data.map((item) {
          moduleList.add(Module.from(item));
        }).toList();

        var moduleBox = await Hive.openBox<Module>('moduleBox');
        await moduleBox.clear();
        await moduleBox.addAll(moduleList);

        change(null, status: RxStatus.success());
        Get.offAndToNamed(RouteName.homepage);

      } catch(e) {
        errorMessage(e.toString());
        change(null, status: RxStatus.error(errorMessage.value));
      }
    } else {
      var moduleBox = await Hive.openBox<Module>('moduleBox');
      if(moduleBox.length > 0) {
        moduleList.clear();
        moduleList.addAll(moduleBox.values);

        change(null, status: RxStatus.success());
        Get.offAndToNamed(RouteName.homepage);
      } else {
        errorMessage(Message.errorConnection);
        openErrorDialog();
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }
}