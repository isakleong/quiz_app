import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/common/message_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/tools/service.dart';
import 'package:quiz_app/tools/utils.dart';
import 'package:quiz_app/widgets/dialog.dart';
import 'package:quiz_app/widgets/textview.dart';

class SplashscreenController extends FullLifeCycleController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;

  var configData = "".obs;
  var moduleList = <Module>[].obs;
  var isNeedUpdate = false.obs;

  //parameter data
  var salesIdParams = "".obs;
  var customerIdParams = "".obs;
  var isCheckInParams = "".obs;

  @override
  void onInit() {
    super.onInit();

    ever(isError, (bool success) {
      if (success) {
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
    });

    syncAppsReady();
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
      status = await Permission.storage.request();
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
    isLoading(true);
    isError(false);

    bool isConnected = await ApiClient().checkConnection();
    if(isConnected) {
      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String appName = packageInfo.appName;
        String currentVersion = packageInfo.version;

        final result = await ApiClient().getData("/config?app=$appName");
        var data = jsonDecode(result.toString());

        String latestVersion = data[0]["Value"];
        int currentVersionConverted = Utils().convertVersionNumber(currentVersion);
        int latestVersionConverted = Utils().convertVersionNumber(latestVersion);

        if(latestVersionConverted > currentVersionConverted) {
          isLoading(false);
          appsDialog(
            type: "app_info",
            title: const TextView(
              headings: "H4",
              text: "Terdapat versi aplikasi yang lebih baru.\n\nIkuti langkah-langkah berikut :\n1. Tekan OK untuk kembali ke aplikasi SFA.\n2. Tekan menu Pengaturan.\n3. Tekan tombol Unduh Aplikasi Utility.\n4. Tunggu hingga proses update selesai.",
              textAlign: TextAlign.start,
            ),
            leftBtnMsg: "nasi goreng ok",
            isAnimated: true,
            leftActionClick: () {
              Get.back();
              SystemNavigator.pop();
            }
          );
        } else {
          //SalesID;CustID;LocCheckIn
          String parameter = await Utils().readParameter();
          if(parameter != "") {
            var arrParameter = parameter.split('.');
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

          getModuleData();
        }
      } catch(e) {
        isLoading(false);
        isError(true);
        errorMessage(e.toString());
      }
    } else {
      isLoading(false);
      isError(true);
      errorMessage(Message.errorConnection);
    }
  }

  getModuleData() async {
    bool isConnected = await ApiClient().checkConnection();
    if(isConnected) {
      moduleList.clear();

      try {
        final result = await ApiClient().getData("/module?sales_id=${salesIdParams.value}");
        var data = jsonDecode(result.toString());
        data.map((item) {
          moduleList.add(Module.from(item));
        }).toList();

        isLoading(false);
        isError(false);
        Get.offAndToNamed(RouteName.homepage);

      } catch(e) {
        isLoading(false);
        isError(true);
        errorMessage(e.toString());
      }
    } else {
      isLoading(false);
      isError(true);
      errorMessage(Message.errorConnection);
    }
  }
}