import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/tools/service.dart';
import 'package:quiz_app/widgets/dialog.dart';
import 'package:quiz_app/widgets/textview.dart';

class SplashscreenController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;

  var configData = "".obs;
  var moduleList = <Module>[].obs;
  var isNeedUpdate = false.obs;

  var isLoadingVersion = false.obs;
  var isDownloadNewVersion = true.obs;
  var isRetryDownload = false.obs;
  var progress = 0.obs;
  late StateSetter _setState;

  @override
  void onInit() {
    super.onInit();

    ever(isError, (bool success) {
      if (success) {
        appsDialog(
          type: "app_error",
          title:  Obx(() => TextView(
            headings: "H4",
            text: "Error message :\n${errorMessage.value.capitalize}", 
            textAlign: TextAlign.start,
            fontSize: 16,
            ),
          ),
          leftBtnMsg: "Ok",
          animated: true,
          actionClick: () {
            Get.back();
          }
        );
      }
    });

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
        appsDialog(
          type: "app_info",
          title: const TextView(
            headings: "H4",
            text: "Terdapat versi aplikasi yang lebih baru.", 
            textAlign: TextAlign.center,
            fontSize: 16,
          ),
          leftBtnMsg: "Update",
          animated: true,
          actionClick: () {
            Get.back();
            updateApps();
          }
        );

      } else {
        Get.offAndToNamed(RouteName.homepage);
      }

    } catch(e) {
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
    }
  }

  Future<bool> isInternet() async {
    bool isInternetCheck = true;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //connected to internet
        isInternetCheck = true;
      }
    } on SocketException catch (_) {
      //not connected to internet
      isRetryDownload(true);
      isInternetCheck = false;
    }
    return isInternetCheck;
  }

  void updateApps() {
    isLoadingVersion(false);
    isDownloadNewVersion(true);

    Timer.periodic(const Duration(seconds: 5), (Timer t) => isInternet());

    downloadApps();

    Get.dialog(
      WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.5)),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircularPercentIndicator(
                    radius: 120,
                    lineWidth: 10,
                    animation: false,
                    percent: progress / 100,
                    center: TextView(headings: "H2", text: "${progress.toString()}%", fontSize: 30),
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          const TextView(headings: "H3", text: "Mengunduh versi aplikasi yang baru", fontSize: 16),
                          const SizedBox(height: 30),
                          Obx(() => 
                            Visibility(
                              visible: isRetryDownload.value,
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                // width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    downloadApps();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConfig.darkGreen,
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.history),
                                      SizedBox(width: 10),
                                      TextView(headings: "H3", text: "Coba Lagi", fontSize: 16, color: Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppConfig.darkGreen,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> downloadApps() async {
    isRetryDownload(false);

    final isPermissionStorageGranted = await checkAppsPermission('STORAGE');
    final isPermissionInstallGranted = await checkAppsPermission('INSTALL PACKAGES');
    final isPermissionExtStorageGranted = await checkAppsPermission('EXTERNAL STORAGE');

    if (isPermissionStorageGranted && isPermissionInstallGranted && isPermissionExtStorageGranted) {
      var path = '/storage/emulated/0/Download/${AppConfig.appsName}.apk';

      String url = "${AppConfig.initUrl}/${AppConfig.appsName}.apk";
      if (await File(path).exists()) {
        //Get downloaded file length
        int downloadFrom = File(path).lengthSync();
        downloadFile(url, path, downloadFrom: downloadFrom);
      } else {
        downloadFile(url, path, downloadFrom: 0);
      }
    }
  }

  downloadFile(String url, String saveDir, {int downloadFrom = 0}) async {
    await Hive.openBox("appsDownloadBox");
    var appsDownloadBox = Hive.box('appsDownloadBox');

    var httpClient = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    http.Response r = await http.head(Uri.parse(url));

    int downloadUntil = int.parse(r.headers["content-length"].toString());
    if (downloadUntil != appsDownloadBox.get("fileSize")) {
      await appsDownloadBox.put('fileSize', downloadUntil);
      downloadFrom = 0;
    }

    request.headers.addAll({'Range': 'bytes=$downloadFrom-'});
    var response = httpClient.send(request);

    if (downloadFrom == downloadUntil) {
      OpenFile.open(saveDir);
      getModuleData();
      return;
    } else {
      RandomAccessFile raf;
      if (downloadFrom == 0) {
        raf = await File(saveDir).open(mode: FileMode.write);
      } else {
        raf = await File(saveDir).open(mode: FileMode.append);
      }

      int downloaded = downloadFrom;

      response.asStream().listen((http.StreamedResponse r) {
        r.stream.listen((List<int> chunk) async {
          raf.setPositionSync(downloaded);
          raf.writeFromSync(
              chunk);

          downloaded += chunk.length;
          if (r.contentLength != null) {
            _setState(() {
              progress.value = (downloaded / (r.contentLength! + downloadFrom) * 100)
                  .toInt();
            });
          }
        }, onDone: () async {
          raf.close();
          if (r.contentLength == null ||
              (r.contentLength != null &&
                  (r.contentLength! + downloadFrom == downloaded))) {
            Get.back();
            OpenFile.open(saveDir);
            getModuleData();
          }
          return;
        });
      });
    }
  }

}