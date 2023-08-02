import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/common/route_config.dart';
import 'package:sfa_tools/models/module.dart';
import 'package:sfa_tools/models/servicebox.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/dialog.dart';
import 'package:sfa_tools/widgets/textview.dart';

class SplashscreenController extends GetxController with StateMixin {
  var errorMessage = "".obs;

  var appName = "".obs;
  var appVersion = "".obs;
  var moduleList = <Module>[].obs;
  var isNeedUpdate = false.obs;

  //parameter data
  var salesIdParams = "".obs;
  var customerIdParams = "".obs;
  var isCheckInParams = "".obs;

  @override
  void onReady() async {
    super.onReady();
    if(await getPermissionStatus('STORAGE')) {
      if (await getPermissionStatus('EXTERNAL STORAGE')) {
        await getParameterData();
        await getModuleData();
      } else {
        openPermissionRequestDialog('EXTERNAL STORAGE');
      }
    } else {
      openPermissionRequestDialog('STORAGE');
    }
  }

  openErrorDialog() {
    appsDialog(
      type: "app_error",
      title: Obx(
        () => TextView(
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

  Future<bool> getPermissionStatus(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (type == 'STORAGE') {
      if (sdkInt < 33) {
        status = await Permission.storage.status;
      } else {
        status = await Permission.photos.status;
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (sdkInt >= 30) {
        status = await Permission.manageExternalStorage.status;
      } else {
        return true;
      }
    }
    return status == PermissionStatus.granted;
  }

  syncAppsReady(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    if (type == 'STORAGE') {
      if (await checkAppsPermission('STORAGE')) {
        if (sdkInt >= 30) {
          openPermissionRequestDialog('EXTERNAL STORAGE');
        } else {
          syncAppsReady('EXTERNAL STORAGE');
        }
      } else {
        syncAppsReady('STORAGE');
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (await checkAppsPermission('EXTERNAL STORAGE')) {
        await getParameterData();
        await getModuleData();
      } else {
        syncAppsReady('EXTERNAL STORAGE');
      }
    }
  }

  openPermissionRequestDialog(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    if(type == 'STORAGE') {
      appsDialog(
        type: "app_info",
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Mohon bantuannya untuk memberikan izin akses aplikasi dengan menekan tombol ',
                style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
                children: <TextSpan>[
                  TextSpan(text: 'Allow.', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                ],
              ),
            ),
            // RichText(
            //   textAlign: TextAlign.start,
            //   text: TextSpan(
            //     text: 'Jika tombol Allow tidak muncul, maka:\n ',
            //     style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
            //     children: <TextSpan>[
            //       sdkInt < 30 ?
            //       const TextSpan(text: '1.  Tekan Permissions.\n2.  Aktifkan Storage.', style: TextStyle(fontFamily: "Poppins"))
            //       :
            //       const TextSpan(text: '1.  Tekan Permissions.\n2.  Tekan (Storage) / (Files and Media)\n3.  Tekan Allow access to media only.', style: TextStyle(fontFamily: "Poppins"))
            //     ],
            //   ),
            // ),
          ],
        ),
        isAnimated: true,
        leftBtnMsg: "Ok",
        leftActionClick: () async {
          Get.back();
          await syncAppsReady('STORAGE');
        }
      );
    } else if(type == 'EXTERNAL STORAGE') {
      appsDialog(
        type: "",
        title: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: 'Mohon bantuannya untuk memberikan izin akses aplikasi dengan ',
            style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
            children: <TextSpan>[
              TextSpan(text: 'mengaktifkan ', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
              TextSpan(text: 'aplikasi SFA Tools seperti pada gambar.', style: TextStyle(fontFamily: "Poppins")),
            ],
          ),
        ),
        isAnimated: false,
        iconAsset: sdkInt < 31 ? 'assets/images/bg-permission-os11.jpg' : 'assets/images/bg-permission-os13.jpg',
        leftBtnMsg: "Ok",
        leftActionClick: () async {
          Get.back();
          await syncAppsReady('EXTERNAL STORAGE');
        }
      );
    }
  }

  Future<bool> checkAppsPermission(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (type == 'STORAGE') {
      if (sdkInt < 33) {
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
        if(type == 'STORAGE') {
          status = await Permission.storage.status;
        } else if (type == 'EXTERNAL STORAGE') {
          status = await Permission.manageExternalStorage.status;
        }

        while (status != PermissionStatus.granted) {
          await openAppSettings();
          if(type == 'STORAGE') {
            status = await Permission.storage.status;
          } else if (type == 'EXTERNAL STORAGE') {
            status = await Permission.manageExternalStorage.status;
          }
        }

        return status == PermissionStatus.granted;
      }
    }
    return status == PermissionStatus.granted;
  }

  getModuleData() async {
    change(null, status: RxStatus.loading());

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if (isConnected) {
      moduleList.clear();

      if (salesIdParams.value != "") {
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

          await checkVersion();

          if (isNeedUpdate.value) {
            change(null, status: RxStatus.success());
            appsDialog(
              type: "app_info",
              title: TextView(
                headings: "H4",
                text: "Terdapat versi aplikasi yang lebih baru.\n\nIkuti langkah-langkah berikut :\n1. Tekan OK untuk kembali ke aplikasi SFA.\n2. Tekan menu Pengaturan.\n3. Tekan tombol Unduh Aplikasi ${appName.value}.\n4. Tunggu hingga proses update selesai.",
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
            await postTrackingVersion();
          }
        } catch (e) {
          errorMessage(e.toString());
          openErrorDialog();
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        errorMessage(Message.errorParameterData);
        openErrorDialog();
        change(null, status: RxStatus.error(errorMessage.value));
      }
    } else {
      var moduleBox = await Hive.openBox<Module>('moduleBox');
      if (moduleBox.length > 0) {
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

  checkVersion() async {
    isNeedUpdate(false);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    appVersion.value = currentVersion;

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if (salesIdParams.value != "") {
      if (isConnected) {
        try {
          final encryptedParam = await Utils.encryptData(salesIdParams.value);

          final result = await ApiClient().getData(urlAPI, "/version?sales_id=$encryptedParam");
          var data = jsonDecode(result.toString());

          String latestVersion = data[0]["Value"];
          appName.value = data[0]["AppName"];

          int currentVersionConverted = Utils().convertVersionNumber(currentVersion);
          int latestVersionConverted = Utils().convertVersionNumber(latestVersion);

          //compare latest version with module version (if module version is bigger than latest version, then app should be updated)
          bool moduleVersionStatus = true;
          int cntPendingData = 0; //count pending data (if there is pending data, then app should not be updated)

          Box retrySubmitQuizBox = await Hive.openBox<ServiceBox>(AppConfig.boxSubmitQuiz);
          var isRetrySubmit = retrySubmitQuizBox.get(AppConfig.keyStatusBoxSubmitQuiz);
          retrySubmitQuizBox.close();

          if (isRetrySubmit != null && isRetrySubmit.value == "true") {
            cntPendingData = 1;
          }

          for (int i = 0; i < moduleList.length; i++) {
            int moduleVersionConverted = Utils().convertVersionNumber(moduleList[i].version);
            if (moduleVersionConverted > currentVersionConverted) {
              moduleVersionStatus = false;
              break;
            }
          }

          if (latestVersionConverted > currentVersionConverted && !moduleVersionStatus && cntPendingData == 0) {
            isNeedUpdate(true);
          }
        } catch (e) {
          errorMessage.value = e.toString();
          openErrorDialog();
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        var moduleBox = await Hive.openBox<Module>('moduleBox');
        if (moduleBox.length > 0) {
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
    } else {
      errorMessage(Message.errorParameterData);
      openErrorDialog();
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

  postTrackingVersion() async {
    var trackVersionBox = await Hive.openBox('trackVersionBox');
    var trackVersion = trackVersionBox.get('trackVersion');

    if (trackVersion != null && trackVersion != "") {
      var now = DateTime.now();
      var lastUpdated = trackVersionBox.get('lastUpdatedVersion');
      var formatter = DateFormat('yyyy-MM-dd');

      String strLastUpdated = formatter.format(lastUpdated);
      String strCurrentDate = formatter.format(now);
      int mLastUpdated = int.parse(strLastUpdated.substring(5, 7));
      int yLastUpdated = int.parse(strLastUpdated.substring(0, 4));
      int mCurrentDate = int.parse(strCurrentDate.substring(5, 7));
      int yCurrentDate = int.parse(strCurrentDate.substring(0, 4));

      bool submitVersion = false;
      if (mCurrentDate - mLastUpdated > 0 || yCurrentDate > yLastUpdated){
        submitVersion=true;
      }
      else {
        submitVersion=false;
      }

      var salesIdVersion = trackVersionBox.get('salesIdVersion');

      if (submitVersion || salesIdParams.value != salesIdVersion || trackVersion != appVersion.value) {
        var connTest = await ApiClient().checkConnection();
        var arrConnTest = connTest.split("|");
        bool isConnected = arrConnTest[0] == 'true';
        String urlAPI = arrConnTest[1];

        if (isConnected) {
          try {
            var params = {
              'sales_id': salesIdParams.value,
              'version': appVersion.value,
            };

            var bodyData = jsonEncode(params);
            var resultSubmit = await ApiClient().postData(
                urlAPI,
                '/version/track',
                Utils.encryptData(bodyData),
                Options(
                  headers: {
                  HttpHeaders.contentTypeHeader: "application/json"
                }
              )
            );

            if (resultSubmit == "success") {
              change(null, status: RxStatus.success());
              Get.offAndToNamed(RouteName.homepage);
            } else {
              errorMessage.value = resultSubmit;
              openErrorDialog();
              change(null, status: RxStatus.error(errorMessage.value));
            }
          } catch (e) {
            errorMessage.value = e.toString();
            openErrorDialog();
            change(null, status: RxStatus.error(errorMessage.value));
          }
        } else {
          errorMessage(Message.errorConnection);
          openErrorDialog();
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        change(null, status: RxStatus.success());
        Get.offAndToNamed(RouteName.homepage);
      }
    } else {
      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];

      if (isConnected) {
        try {
          var params = {
            'sales_id': salesIdParams.value,
            'version': appVersion.value,
          };

          var bodyData = jsonEncode(params);
          var resultSubmit = await ApiClient().postData(
              urlAPI,
              '/version/track',
              Utils.encryptData(bodyData),
              Options(
                headers: {
                HttpHeaders.contentTypeHeader: "application/json"
              }
            )
          );

          if (resultSubmit == "success") {
            trackVersionBox.put("trackVersion", appVersion.value);
            trackVersionBox.put("salesIdVersion", salesIdParams.value);
            trackVersionBox.put("lastUpdatedVersion", DateTime.now());

            change(null, status: RxStatus.success());
            Get.offAndToNamed(RouteName.homepage);
          } else {
            errorMessage.value = resultSubmit;
            openErrorDialog();
            change(null, status: RxStatus.error(errorMessage.value));
          }
        } catch (e) {
          errorMessage.value = e.toString();
          openErrorDialog();
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } else {
        errorMessage(Message.errorConnection);
        openErrorDialog();
        change(null, status: RxStatus.error(errorMessage.value));
      }
    }
  }

  buttonAction(String moduleid) {
    if (moduleid == 'Kuis') {
      Get.toNamed(RouteName.quizDashboard);
    }
  }

  getParameterData() async {
    //SalesID;CustID;LocCheckIn
    String parameter = await Utils().readParameter();
    if (parameter != "") {
      var arrParameter = parameter.split(';');
      for (int i = 0; i < arrParameter.length; i++) {
        if (i == 0) {
          salesIdParams.value = arrParameter[i];
        } else if (i == 1) {
          customerIdParams.value = arrParameter[i];
        } else {
          isCheckInParams.value = arrParameter[2];
        }
      }
    }
  }
}
