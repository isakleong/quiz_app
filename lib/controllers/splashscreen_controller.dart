import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/common/route_config.dart';
import 'package:sfa_tools/controllers/background_service_controller.dart';
import 'package:sfa_tools/models/customer.dart';
import 'package:sfa_tools/models/loginmodel.dart';
import 'package:sfa_tools/models/module.dart';
import 'package:sfa_tools/models/outstandingdata.dart';
import 'package:sfa_tools/models/shiptoaddress.dart';
import 'package:sfa_tools/models/vendor.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/dialog.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:shimmer/shimmer.dart';
import '../common/hivebox_vendor.dart';
import '../models/detailproductdata.dart';
import '../models/masteritemmodel.dart';
import '../models/productdata.dart';
import 'package:http/http.dart' as http;

class SplashscreenController extends GetxController with StateMixin implements WidgetsBindingObserver {
  var errorMessage = "".obs;
  var isError = false.obs;
  bool retrypermission = false;

  var appName = "".obs;
  var appVersion = "".obs;
  var moduleList = <Module>[].obs;
  var isNeedUpdate = false.obs;

  //permission data
  var cntStoragePermissionDeny = 0.obs;
  var isOpenSettings = false.obs;

  //parameter data
  var salesIdParams = "".obs;
  var customerIdParams = "".obs;
  var isCheckInParams = "".obs;

  @override
  void onInit() {
    super.onInit();

    isError(false);
    // Add the controller as an observer when it's initialized
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (isOpenSettings.value) {
        isOpenSettings(false);
        await syncAppsReady('STORAGE');
      } else {
        if (Get.currentRoute.toString() != "/") {
          await Get.deleteAll(force: true);
          // Get.offAndToNamed(RouteName.splashscreen);
          Get.offAllNamed(RouteName.splashscreen);
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    startApp();
  }

  startApp() async {
    if (await getPermissionStatus('STORAGE')) {
      if (await getPermissionStatus('EXTERNAL STORAGE')) {
        //reset permanent deny permission flag
        cntStoragePermissionDeny.value = 0;

        await getParameterData();
        await getmoduledataall();
      } else {
        await openPermissionRequestDialog('EXTERNAL STORAGE');
      }
    } else {
      await openPermissionRequestDialog('STORAGE');
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
        });
  }

  Future<bool> getPermissionStatus(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (type == 'STORAGE') {
      if (sdkInt! < 33) {
        status = await Permission.storage.status;
      } else {
        status = await Permission.photos.status;
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (sdkInt! >= 30) {
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
        if (sdkInt! >= 30) {
          var status = await Permission.manageExternalStorage.status;
          if (status != PermissionStatus.granted) {
            openPermissionRequestDialog('EXTERNAL STORAGE');
          } else {
            await getParameterData();
            await getmoduledataall();
          }
        } else {
          syncAppsReady('EXTERNAL STORAGE');
        }
      } else {
        openPermissionRequestDialog('STORAGE');
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (await checkAppsPermission('EXTERNAL STORAGE')) {
        await getParameterData();
        await Backgroundservicecontroller().initializeNotifConfiguration();
        await getmoduledataall();
      } else {
        openPermissionRequestDialog('EXTERNAL STORAGE');
      }
    }
  }

  openPermissionRequestDialog(String type, {bool? actionButton}) async {
    retrypermission = false;

    if (type == 'STORAGE') {
      try {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        appsDialog(
          type: "app_info",
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text:
                      'Mohon bantuannya untuk memberikan izin akses aplikasi dengan menekan tombol ',
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Allow.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins")),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text:
                      'Jika tombol Allow tidak muncul, ikuti langkah berikut:\n ',
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
                  children: <TextSpan>[
                    sdkInt == 30
                        ? const TextSpan(
                            text: '1.  Tekan ',
                            style: TextStyle(fontFamily: "Poppins"),
                            children: [
                                TextSpan(
                                    text: 'Permissions.\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text: '2.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins")),
                                TextSpan(
                                    text: 'Storage.\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text: '3.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins")),
                                TextSpan(
                                    text: 'Allow access to media only.\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text: '4.  Tekan tombol ',
                                    style: TextStyle(fontFamily: "Poppins")),
                                TextSpan(
                                    text: 'Kembali (Back).\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                              ])
                        : sdkInt == 31 || sdkInt == 32
                            ? const TextSpan(
                                text: '1.  Tekan ',
                                style: TextStyle(fontFamily: "Poppins"),
                                children: [
                                    TextSpan(
                                        text: 'Permissions.\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                    TextSpan(
                                        text: '2.  Tekan ',
                                        style:
                                            TextStyle(fontFamily: "Poppins")),
                                    TextSpan(
                                        text: 'Files and Media.\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                    TextSpan(
                                        text: '3.  Tekan ',
                                        style:
                                            TextStyle(fontFamily: "Poppins")),
                                    TextSpan(
                                        text: 'Allow access to media only.\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                    TextSpan(
                                        text: '4.  Tekan tombol ',
                                        style:
                                            TextStyle(fontFamily: "Poppins")),
                                    TextSpan(
                                        text: 'Kembali (Back).\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins")),
                                  ])
                            : sdkInt! >= 33
                                ? const TextSpan(
                                    text: '1.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins"),
                                    children: [
                                        TextSpan(
                                            text: 'Permissions.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '2.  Tekan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Photos and videos.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '3.  Tekan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Allow.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '4.  Tekan tombol ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Kembali (Back).\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                      ])
                                :
                                //below android 30 (should not happen because all device installed in office already os 11 or higher)
                                const TextSpan(
                                    text: '1.  Tekan ',
                                    style: TextStyle(fontFamily: "Poppins"),
                                    children: [
                                        TextSpan(
                                            text: 'Permissions.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '2.  Tekan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Storage.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '3.  Aktifkan atau Hidupkan ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Storage.\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: '4.  Tekan tombol ',
                                            style: TextStyle(
                                                fontFamily: "Poppins")),
                                        TextSpan(
                                            text: 'Kembali (Back).\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Poppins")),
                                      ])
                  ],
                ),
              ),
            ],
          ),
          isAnimated: true,
          leftBtnMsg: "Ok",
          leftActionClick: () async {
            if (cntStoragePermissionDeny > 0) {
              Get.back();
              await openAppSettings();
              isOpenSettings(true);
              // await syncAppsReady('STORAGE');
            } else {
              Get.back();
              await syncAppsReady('STORAGE');
            }
          });
      } catch (e) {
        retrypermission = true;
        errorMessage("gagal meminta perizinan penyimpanan ! ${e.toString()}");
        openErrorDialog();
        isError(true);
        change(null, status: RxStatus.error("gagal meminta perizinan penyimpanan ! ${e.toString()}"));
      } 
    } else if (type == 'EXTERNAL STORAGE') {
      try {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        appsDialog(
          type: "",
          title: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text:
                  'Mohon bantuannya untuk memberikan izin akses aplikasi dengan ',
              style: TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
              children: <TextSpan>[
                TextSpan(
                    text: 'mengaktifkan ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                TextSpan(
                    text: 'aplikasi SFA Tools seperti pada gambar.',
                    style: TextStyle(fontFamily: "Poppins")),
              ],
            ),
          ),
          isAnimated: false,
          iconAsset: sdkInt! < 31
              ? 'assets/images/bg-permission-os11.jpg'
              : 'assets/images/bg-permission-os13.jpg',
          leftBtnMsg: "Ok",
          leftActionClick: () async {
            Get.back();
            await syncAppsReady('EXTERNAL STORAGE');
          });
      } catch (e) {
        retrypermission = true;
        errorMessage("gagal meminta perizinan penyimpanan eksternal ! ${e.toString()}");
        openErrorDialog();
        isError(true);
        change(null, status: RxStatus.error("gagal meminta perizinan penyimpanan eksternal ! ${e.toString()}"));
      }
    }
  }

  Future<bool> checkAppsPermission(String type) async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    // ignore: prefer_typing_uninitialized_variables
    var status;
    if (type == 'STORAGE') {
      if (sdkInt! < 33) {
        if (cntStoragePermissionDeny.value > 0) {
          status = await Permission.storage.status;
        } else {
          status = await Permission.storage.request();
        }
      } else {
        //if you need the access for both photos and videos,
        //you can use either Permission.photos or Permission.video, you don’t need both of them,
        //because in Granular Media the access is granted for both media types.
        if (cntStoragePermissionDeny.value > 0) {
          var statusPhoto = await Permission.photos.status;
          var statusVideo = await Permission.videos.status;
          if (statusPhoto == PermissionStatus.granted ||
              statusVideo == PermissionStatus.granted) {
            status = PermissionStatus.granted;
          }
        } else {
          status = await Permission.photos.request();
        }
      }
    } else if (type == 'INSTALLS PACKAGES') {
      if (sdkInt! >= 26) {
        status = await Permission.requestInstallPackages.request();
      } else {
        return true;
      }
    } else if (type == 'EXTERNAL STORAGE') {
      if (sdkInt! >= 30) {
        status = await Permission.manageExternalStorage.request();
      } else {
        return true;
      }
    }

    if (status != PermissionStatus.granted) {
      if (status == PermissionStatus.denied) {
        cntStoragePermissionDeny.value++;
        return status == PermissionStatus.granted;
      } else if (status == PermissionStatus.permanentlyDenied) {
        if (type == 'STORAGE') {
          status = await Permission.storage.status;
        } else if (type == 'EXTERNAL STORAGE') {
          status = await Permission.manageExternalStorage.status;
        }

        cntStoragePermissionDeny.value++;

        return status == PermissionStatus.granted;
      }
    }
    return status == PermissionStatus.granted;
  }

  getmoduledataall() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    appVersion.value = currentVersion;
    await postTrackingVersion();
  }

  postTrackingVersion() async {
    try {
      var trackVersionBox = await Hive.openBox('trackVersionBox');
      var trackVersion = trackVersionBox.get('trackVersion');
      var lastUpdated = trackVersionBox.get('lastUpdatedVersion');

      if ((trackVersion != null && trackVersion != "") && (lastUpdated != null && lastUpdated != "")) {
        var now = DateTime.now();

        var formatter = DateFormat('yyyy-MM-dd');
        String strLastUpdated = formatter.format(lastUpdated);
        String strCurrentDate = formatter.format(now);

        int mLastUpdated = int.parse(strLastUpdated.substring(5, 7));
        int yLastUpdated = int.parse(strLastUpdated.substring(0, 4));
        int mCurrentDate = int.parse(strCurrentDate.substring(5, 7));
        int yCurrentDate = int.parse(strCurrentDate.substring(0, 4));

        bool submitVersion = false;
        if (mCurrentDate - mLastUpdated > 0 || yCurrentDate > yLastUpdated) {
          submitVersion = true;
        } else {
          submitVersion = false;
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
                  Options(headers: {
                    HttpHeaders.contentTypeHeader: "application/json"
                  }));

              if (resultSubmit == "success") {
                change(null, status: RxStatus.success());
                Get.offAndToNamed(RouteName.homepage);
                await Future.delayed(Duration(milliseconds: 250));
                await cekDeviceState();
              } else {
                errorMessage.value = resultSubmit;
                openErrorDialog();
                isError(true);
                change(null, status: RxStatus.error(errorMessage.value));
              }
            } catch (e) {
              errorMessage.value = e.toString();
              openErrorDialog();
              isError(true);
              change(null, status: RxStatus.error(errorMessage.value));
            }
          } else {
            errorMessage(Message.errorConnection);
            openErrorDialog();
            isError(true);
            change(null, status: RxStatus.error(errorMessage.value));
          }
        } else {
          change(null, status: RxStatus.success());
          Get.offAndToNamed(RouteName.homepage);
          await Future.delayed(Duration(milliseconds: 250));
          await cekDeviceState();
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
                Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json"
                }));

            if (resultSubmit == "success") {
              trackVersionBox.put("trackVersion", appVersion.value);
              trackVersionBox.put("salesIdVersion", salesIdParams.value);
              trackVersionBox.put("lastUpdatedVersion", DateTime.now());

              change(null, status: RxStatus.success());
              Get.offAndToNamed(RouteName.homepage);
              await Future.delayed(Duration(milliseconds: 250));
              await cekDeviceState();
            } else {
              errorMessage.value = resultSubmit;
              openErrorDialog();
              isError(true);
              change(null, status: RxStatus.error(errorMessage.value));
            }
          } catch (e) {
            errorMessage.value = e.toString();
            openErrorDialog();
            isError(true);
            change(null, status: RxStatus.error(errorMessage.value));
          }
        } else {
          errorMessage(Message.errorConnection);
          openErrorDialog();
          isError(true);
          change(null, status: RxStatus.error(errorMessage.value));
        }
      }
    } catch (e) {
      print(e);
      Get.offAndToNamed(RouteName.homepage);
      await Future.delayed(Duration(milliseconds: 250));
      await cekDeviceState();
    }
    
  }

  buttonAction(String moduleid) {
    if (moduleid == 'Kuis') {
      Get.toNamed(RouteName.quizDashboard);
    } else {
      String pattern = "Taking order ";
      selectedVendor.value = moduleid.substring(pattern.length);
      Get.toNamed(RouteName.takingOrderVendor);
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

 //untuk unduh ulang data
  RxList<String> progressdownload = <String>[].obs; // digunakan untuk memunculkan 5 lingkaran
  //desc lingkaran
  // 1. proses unduh module
  // 2. proses unduh datarute
  // 3. proses unduh datacustomer
  // 4. proses unduh data item
  // 5. proses unduh config txt informasi
  late dynamic jsonstate;
  List<Vendor> vendorlistunduhulang = <Vendor>[];
  var versimodulvendor = '';
  var ordermodulvendor = '';
  GlobalKey keyhome = GlobalKey();
  RxBool isdoneloading = false.obs;
  RxString selectedVendor = "".obs;
  GlobalKey keybanner = GlobalKey();
  String cekstatedevice = 'cekdevicestate';
  String redownload = 'unduhulang';
  bool forcedownload = false;
  late DateTime bannershowup;
  
  loginApiVendor() async {
    try {
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];
      if(!isConnected){
        return;
      }
      String salesid = await Utils().getParameterData('sales');
      String encparam = Utils().encryptsalescodeforvendor(salesid);
      var params = {
        "username" : encparam
      };
      var result = await ApiClient().postData(urlAPI,"${AppConfig.apiurlvendorpath}/api/login",
            params,
            Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      var dataresp = LoginResponse.fromJson(result);
      await Utils().managetokenbox('open');
      if(!tokenbox.isOpen){
        tokenbox = await Hive.openBox('tokenbox');
      }
      tokenbox.delete(salesid);
      tokenbox.put(salesid, dataresp.data!.token);
      await Utils().managetokenbox('close');
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  Future<bool> _onWillPop() async {
    try {
    // asumsi banner stuck, maka bisa dispose jika klik back (dengan menunggu selama N)
    DateTime backclick = DateTime.now();
    int differenceInSeconds = backclick.isBefore(bannershowup)
      ? bannershowup.difference(backclick).inSeconds
      : backclick.difference(bannershowup).inSeconds;
      print(differenceInSeconds);
      if (differenceInSeconds > 180){
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  showLoadingBanner(BuildContext ctx){
    bannershowup = DateTime.now();
    progressdownload.clear();
    for (var i = 0; i < 5; i++) {
      progressdownload.add('');
    }
    double width = MediaQuery.of(ctx).size.width;
    double height = MediaQuery.of(ctx).size.height;
    Get.dialog(
      barrierDismissible: false,
      WillPopScope(
        onWillPop: _onWillPop,
        child: Dialog(
          key: keybanner,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: SizedBox(
                width: width * 0.8,
                height: 0.25 * height,
                child: Stack(
                  children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  const TextView(text: "Mohon Menunggu",fontSize: 18, headings: 'H2'),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Obx(()=>Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for(var k =0; k< progressdownload.length;k++)
                        progressdownload[k] == ''? 
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 0.1 * width,
                              height: 0.1 * width,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                            ),
                          ) : progressdownload[k] == 'ok'? Container(
                              width: 0.1 * width,
                              height: 0.1 * width,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ) : Container(
                              width: 0.1 * width,
                              height: 0.1 * width,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            )
                        // Lottie.asset('assets/lottie/${progressdownload[k]}', width: width * 0.25),
                  ],))
                ],
              ),
            ),
          ],
        ),
          )),
      ));
  }

  unduhDataRoute() async {
    try {
      final encryptedParam = await Utils.encryptData(await Utils().getParameterData("sales"));
      var postbody = {
        'sales' : encryptedParam
      };
      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
        for (var i = 1; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
        }
        isdoneloading.value = true;
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        return;
      }
      String urlAPI = arrConnTest[1];
      final response = await http.post(Uri.parse("$urlAPI/getcustbyroute"),headers: {"Content-Type": "application/json",}, body: jsonEncode(postbody));
      var datajson = jsonDecode(response.body);
      // var sizejson = Utils().calculateJsonSize(datajson);
      // print("2. data rute : ${sizejson.toString()}");
      if(datajson['data'].length != 0){
        progressdownload[1] = 'ok';
        unduhDataCustomer(datajson['data'],false);
      } else {
        progressdownload[1] = 'ok';
        unduhDataCustomer('',false);
      }
    } catch (e) {
      //error tidak bisa update
      for (var i = 1; i < progressdownload.length; i++) {
        await Future.delayed(Duration(milliseconds: 250));
        progressdownload[i] = 'bad';
      }
      isdoneloading.value = true;
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
    }
  }

  unduhDataCustomer(dynamic listcust,bool issinglecust) async {
    try {
      //connection test
      String salesid = await Utils().getParameterData('sales');
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
        if(issinglecust){
          return;
        }
        for (var i = 2; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
        }
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        isdoneloading.value = true;
        return;
      }
      String urlAPI = arrConnTest[1];

      //access api
      await Utils().managetokenbox('open');
      var tokenboxdata = await tokenbox.get(salesid);
      var dectoken = Utils().decrypt(tokenboxdata);
      await Utils().managetokenbox('close');
      final url = Uri.parse('$urlAPI${AppConfig.apiurlvendorpath}/api/setting/multi-customer-info');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $dectoken',
      });
      if(listcust != ''){
        for (var i = 0; i < listcust.length; i++) {
          request.fields['customers[$i]'] = listcust[i]['CustID'];
        }
      }
      var custtxt = await Utils().getParameterData('cust');
      if(listcust == "" && custtxt != null && custtxt != "" || issinglecust){
        request.fields['customers[0]'] = await Utils().getParameterData('cust');
      } else if(custtxt != null && custtxt != "" && issinglecust == false){
        request.fields['customers[${listcust.length}]'] = await Utils().getParameterData('cust');
      }
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      var datadecoded = jsonDecode(responseString);
      // var sizejson = Utils().calculateJsonSize(datadecoded);
      // print("3. data customer : ${sizejson.toString()}");

      //data customer,outstanding,piutang dan alamat
      await Utils().managecustomerbox('open');
      await Utils().manageshipbox('open');
      await Utils().manageoutstandingbox('open');
      await Utils().managepiutangbox('open');

      /*clear old data
      if(datadecoded['customers'].length != 0){
        List<dynamic> keyscustomer = customerBox.keys.toList();
        await customerBox.deleteAll(keyscustomer);
        await Utils().managecustomerbox('close');
      }*/

      for (var i = 0; i < datadecoded['customers'].length; i++) {
        Customer datacust = Customer.fromJson(datadecoded['customers'][i]['customer']);
        if(!customerBox.isOpen) await Utils().managecustomerbox('open');
        await customerBox.delete(datacust.no);
        await customerBox.put(datacust.no,datacust);
        await piutangBox.delete('$salesid|${datacust.no}');
        var makejsonpiutang = {
          'receivables' : datadecoded['customers'][i]['receivables'],
          'overdueInvoices': datadecoded['customers'][i]['overdueInvoices']
        };
        await piutangBox.put('$salesid|${datacust.no}', jsonEncode(makejsonpiutang));
        await outstandingBox.delete("$salesid|${datacust.no}");
        List<OutstandingData> listoutstanding = <OutstandingData>[];
        if(datadecoded['customers'][i]['outstanding'].length != 0){
          for (var k = 0; k < datadecoded['customers'][i]['outstanding'].length; k++) {
            listoutstanding.add(OutstandingData.fromJson(datadecoded['customers'][i]['outstanding'][k]));
          }
        }
        if (listoutstanding.isNotEmpty) {
          var makejson = {
            "data": datadecoded['customers'][i]['outstanding'],
            "timestamp": DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())
          };
          await outstandingBox.put("$salesid|${datacust.no}", jsonEncode(makejson));
        }
        List<ShipToAddress> listaddrcust = <ShipToAddress>[];
        if(datadecoded['customers'][i]['shipToAddresses'].length != 0){
          for (var j = 0; j < datadecoded['customers'][i]['shipToAddresses'].length; j++) {
            if(!shiptobox.isOpen) await Utils().manageshipbox('open');
            await shiptobox.delete(datacust.no);
            if(datadecoded['customers'][i]['shipToAddresses'][j].length != 0){
              listaddrcust.add(ShipToAddress.fromJson(datadecoded['customers'][i]['shipToAddresses'][j]));
            }
          }
        }
        if(listaddrcust.isNotEmpty){
          if(!shiptobox.isOpen) await Utils().manageshipbox('open');
          await shiptobox.put(datacust.no,listaddrcust);
        }
      }
      await Utils().managecustomerbox('close');
      await Utils().manageshipbox('close');
      await Utils().manageoutstandingbox('close');
      await Utils().managepiutangbox('close');

      //bank data
      await Utils().managebankbox('open');
      await bankbox.delete(salesid);
      if(datadecoded['banks'].length != 0){
        await bankbox.put(salesid, datadecoded['banks']);
      } else {
        if(!issinglecust){
          progressdownload[2] = 'bad';
        }
      }
      await Utils().managebankbox('close');

      //payment methods data
      await Utils().managepaymentmethodsbox('open');
      await paymentMethodsBox.delete(salesid);
      if(datadecoded['paymentMethods'].length != 0){
        await paymentMethodsBox.put(salesid, datadecoded['paymentMethods']);
      } else {
        if(!issinglecust){
          progressdownload[2] = 'bad';
        }
      }
      await Utils().managepaymentmethodsbox('close');
      if(issinglecust){
        return;
      }

      if(!issinglecust){
        if(progressdownload[2] != 'bad'){
          progressdownload[2] = 'ok';
        }
      }
      
      unduhDataItem();
      return;
    } on SocketException{
        await Utils().managetokenbox('close');
        await Utils().managecustomerbox('close');
        if(issinglecust){
          return;
        }
        for (var i = 2; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
        }
        isdoneloading.value = true;
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        return;
    } catch (e) {
        print(e.toString());
        await Utils().managetokenbox('close');
        await Utils().managecustomerbox('close');
        if(issinglecust){
          return;
        }
        progressdownload[2] = 'bad';
        unduhDataItem();
        return;
    }
  }

  unduhDataItem() async {
    try {
      vendorlistunduhulang.clear();
      String salesid = await Utils().getParameterData('sales');
      String custid = await Utils().getParameterData('cust');
      var connTest = await ApiClient().checkConnection(jenis: "vendor");
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
        for (var i = 3; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
        }
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        isdoneloading.value = true;
        return;
      }
      String urlAPI = arrConnTest[1];
      await Utils().managetokenbox('open');
      var tokenboxdata = await tokenbox.get(salesid);
      var dectoken = Utils().decrypt(tokenboxdata);
      await Utils().managetokenbox('close');
      final url = Uri.parse('$urlAPI${AppConfig.apiurlvendorpath}/api/setting/all-items');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $dectoken',
      });
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      var datadecoded = jsonDecode(responseString);
      // var sizejson = Utils().calculateJsonSize(datadecoded);
      // print("4. data item : ${sizejson.toString()}");
      for (var i = 0; i < datadecoded['vendors'].length; i++) {
        vendorlistunduhulang.add(Vendor.fromJson(datadecoded['vendors'][i]));
      }

      //simpan list vendor
      await Utils().managemastervendorbox('open');
      await mastervendorbox.delete(salesid);
      await mastervendorbox.put(salesid,vendorlistunduhulang);
      await Utils().managemastervendorbox('close');

      //simpan list item vendor
      MasterItemModel itemlist = MasterItemModel.fromJson(datadecoded);
      await Utils().managemasteritembox('open');
      await masteritembox.delete('$salesid|${vendorlistunduhulang[0].name}');
      await masteritembox.put('$salesid|${vendorlistunduhulang[0].name}',responseString);
      await Utils().managemasteritembox('close');

      //mencari item sesuai dengan subdis customer
      await Utils().managecustomerbox('open');
      var listcust = customerBox.get(custid);
      await Utils().managecustomerbox('close');
      if(listcust != null){
        List<ProductData> listProduct = <ProductData>[];
        for (var m = 0; m < itemlist.items!.length; m++) {
          for(var k=0; k < itemlist.items![m].subdistricts!.length; k++){
            if(itemlist.items![m].subdistricts![k].name == listcust.city){
              List<DetailProductData> listdetail = [];
              for (var j = 0; j < itemlist.items![m].uoms!.length; j++) {
                listdetail.add(DetailProductData(itemlist.items![m].uoms![j].name!, double.parse(itemlist.items![m].subdistricts![k].price!.toString()), itemlist.items![m].uoms![j].id!, itemlist.items![m].komisi!));
              }
              listProduct.add(ProductData(itemlist.items![m].code!, "${itemlist.items![m].merk!} ${itemlist.items![m].volume!} ${itemlist.items![m].color!} ${itemlist.items![m].desc!}", listdetail,DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),itemlist.items![m].id!));
            }
          }
        }

        if(listProduct.isNotEmpty){

          var globalkeybox = "$salesid|$custid|${vendorlistunduhulang[0].prefix}|${vendorlistunduhulang[0].baseApiUrl}";
          //isi product bisa jual customer
          await Utils().manageitemvendorbox('open');
          await itemvendorbox.delete(globalkeybox);
          await itemvendorbox.put(globalkeybox, listProduct);
          await Utils().manageitemvendorbox('close');

          //isi list vendor customer
          await Utils().managevendorbox('open');
          await vendorBox.delete("$salesid|$custid");
          await vendorBox.put("$salesid|$custid", vendorlistunduhulang);
          await Utils().managevendorbox('close');
          
          //isi data outstanding customer
          await Utils().manageoutstandingbox('open');
          await outstandingBox.delete(globalkeybox);
          var dataoutstandingnew = await outstandingBox.get("$salesid|$custid");
          if(dataoutstandingnew != null){
            await outstandingBox.put(globalkeybox, dataoutstandingnew);
          }
          await Utils().manageoutstandingbox('close');

          //isi data piutang customer
          await Utils().managepiutangbox('open');
          var datapiutangnew = await piutangBox.get('$salesid|$custid');
          var datapiutangold = await piutangBox.get(globalkeybox);
          if (datapiutangnew != null){
            await piutangBox.delete('$salesid|$custid');
          }
          if(datapiutangold != null){
            await piutangBox.delete(globalkeybox);
          }
          await piutangBox.put(globalkeybox,datapiutangnew);
          await Utils().managepiutangbox('close');

          //isi data bank
          await Utils().managebankbox('open');
          var databankall = await bankbox.get(salesid);
          var databankcust = await bankbox.get(globalkeybox);
          if(databankcust != null){
            await bankbox.delete(globalkeybox);
          }
          await bankbox.put(globalkeybox,databankall);
          await Utils().managebankbox('close');

          //isi data payment methods
          await Utils().managepaymentmethodsbox('open');
          var datapaymentall = await paymentMethodsBox.get(salesid);
          var datapaymentcust = await paymentMethodsBox.get(globalkeybox);
          if(datapaymentcust != null){
            await paymentMethodsBox.delete(globalkeybox);
          }
          await paymentMethodsBox.put(globalkeybox,datapaymentall);
          await Utils().managepaymentmethodsbox('close');
          
          //tampilkan modul vendor
          for (var i = 0; i < vendorlistunduhulang.length; i++) {
            moduleList.add(Module(moduleID: "Taking order ${vendorlistunduhulang[i].name}", version: versimodulvendor, orderNumber: ordermodulvendor));
          } 
        }
      }

      progressdownload[3]= "ok";
      if(vendorlistunduhulang.isNotEmpty){
        downloadConfigFile('getinfoproduk');
      } else {
        progressdownload[4] = 'bad';
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        isdoneloading.value = true;
      }
    } on SocketException{
      await Utils().managetokenbox('close');
      for (var i = 3; i < progressdownload.length; i++) {
        await Future.delayed(Duration(milliseconds: 250));
        progressdownload[i] = 'bad';
      }
      isdoneloading.value = true;
      try {
        Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
      } catch (e) {
          
      }
    } catch (e) {
      await Utils().managetokenbox('close');
      for (var i = 3; i < progressdownload.length; i++) {
        await Future.delayed(Duration(milliseconds: 250));
        progressdownload[i] = 'bad';
      }
      isdoneloading.value = true;
      try {
        Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
      } catch (e) {
          
      }
    }
  }

  syncCustomerData(String from) async {
      String salesid = await Utils().getParameterData('sales');
      String custid = await Utils().getParameterData('cust');
      try {
        
        //get list vendor
        await Utils().managemastervendorbox('open');
        var datavendor =  await mastervendorbox.get(salesid);
        await Utils().managemastervendorbox('close');
        List<Vendor> vendorlisthive = <Vendor>[];
        for (var i = 0; i < datavendor.length; i++) {
          vendorlisthive.add(datavendor[i]);
        }

        //get list item vendor
        await Utils().managemasteritembox('open');
        var datadecoded = await masteritembox.get('$salesid|${vendorlisthive[0].name}');
        await Utils().managemasteritembox('close');
        MasterItemModel itemlist = MasterItemModel.fromJson(jsonDecode(datadecoded));

        //get data customer dan cek apakah data lebih dari 1 hari
        await Utils().managecustomerbox('open');
        var listcust = await customerBox.get(custid);
        await Utils().managecustomerbox('close');
        if (custid != "" && listcust == null){
          await loginApiVendor();
          await unduhDataCustomer('', true);
          await Utils().managecustomerbox('open');
          listcust = await customerBox.get(custid);
          await Utils().managecustomerbox('close');
        } else if (custid != "" && listcust != null){
          listcust = listcust as Customer;
          if(Utils().isDateNotToday(Utils().formatDate(listcust.timestamp))){
            await loginApiVendor();
            await unduhDataCustomer('', true);
            await Utils().managecustomerbox('open');
            listcust = await customerBox.get(custid);
            await Utils().managecustomerbox('close');
          }
        }

        //mencari item sesuai dengan subdis customer
        if(listcust != null){
          List<ProductData> listProduct = <ProductData>[];
          for (var m = 0; m < itemlist.items!.length; m++) {
            for(var k=0; k < itemlist.items![m].subdistricts!.length; k++){
              if(itemlist.items![m].subdistricts![k].name == listcust.city){
                List<DetailProductData> listdetail = [];
                for (var j = 0; j < itemlist.items![m].uoms!.length; j++) {
                  listdetail.add(DetailProductData(itemlist.items![m].uoms![j].name!, double.parse(itemlist.items![m].subdistricts![k].price!.toString()), itemlist.items![m].uoms![j].id!, itemlist.items![m].komisi!));
                }
                listProduct.add(ProductData(itemlist.items![m].code!, "${itemlist.items![m].merk!} ${itemlist.items![m].volume!} ${itemlist.items![m].color!} ${itemlist.items![m].desc!}", listdetail,DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),itemlist.items![m].id!));
              }
            }
          }

          if(listProduct.isNotEmpty){

            var globalkeybox = "$salesid|$custid|${vendorlisthive[0].prefix}|${vendorlisthive[0].baseApiUrl}";
            //isi product bisa jual customer
            await Utils().manageitemvendorbox('open');
            await itemvendorbox.delete(globalkeybox);
            await itemvendorbox.put(globalkeybox, listProduct);
            await Utils().manageitemvendorbox('close');

            //isi list vendor customer
            await Utils().managevendorbox('open');
            await vendorBox.delete("$salesid|$custid");
            await vendorBox.put("$salesid|$custid", vendorlisthive);
            await Utils().managevendorbox('close');
            
            //isi data outstanding customer
            await Utils().manageoutstandingbox('open');
            var dataoutstandingvendor = await outstandingBox.get(globalkeybox);
            if(dataoutstandingvendor == null){
              var dataoutstanding = await outstandingBox.get("$salesid|$custid");
              if(dataoutstanding != null){
                await outstandingBox.put(globalkeybox, dataoutstanding);
              }
            }
            await Utils().manageoutstandingbox('close');

            //isi data piutang customer
            await Utils().managepiutangbox('open');
            var datapiutangvendor = await piutangBox.get(globalkeybox);
            if(datapiutangvendor == null){
              var datapiutang = await piutangBox.get("$salesid|$custid");
              if(datapiutang != null){
                await piutangBox.put(globalkeybox, datapiutang);
                await piutangBox.delete("$salesid|$custid");
              }
            }
            await Utils().managepiutangbox('close');

            //isi data bank
            await Utils().managebankbox('open');
            var databank = await bankbox.get(globalkeybox);
            if(databank != null){
              await bankbox.put(globalkeybox,databank);
            } else {
              var databankall = await bankbox.get(salesid);
              if(databankall != null){
                await bankbox.delete(salesid);
                await bankbox.put(globalkeybox,databankall);
              }
            }
            await Utils().managebankbox('close');

            //isi data payment methods
            await Utils().managepaymentmethodsbox('open');
            var datapayment = await paymentMethodsBox.get(globalkeybox);
            if(datapayment != null){
              await paymentMethodsBox.put(globalkeybox,datapayment);
            } else {
              var datapaymentall = await paymentMethodsBox.get(salesid);
              if(datapaymentall != null){
                await paymentMethodsBox.delete(salesid);
                await paymentMethodsBox.put(globalkeybox,datapaymentall);
              }
            }
            await Utils().managepaymentmethodsbox('close');
            
            //tampilkan modul vendor
            var moduleBox = await Hive.openBox('moduleBox');
            var datamodule = await moduleBox.get(salesid);
            await moduleBox.close();
            List<Module> datamoduleconv = <Module>[];
            for (var i = 0; i < datamodule.length; i++) {
              datamoduleconv.add(datamodule[i]);
            }
            moduleList.clear();
            for (var i = 0; i < datamoduleconv.length; i++) {
              moduleList.add(datamoduleconv[i]);
            }
            if(from == "cekdevicestate"){
              var idx = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order"));
              for (var i = 0; i < vendorlisthive.length; i++) {
                moduleList.add(Module(moduleID: "Taking order ${vendorlisthive[i].name}", version: moduleList[idx].version, orderNumber: moduleList[idx].orderNumber));
              }
            } else {
              for (var i = 0; i < vendorlisthive.length; i++) {
                moduleList.add(Module(moduleID: "Taking order ${vendorlisthive[i].name}", version: versimodulvendor, orderNumber: ordermodulvendor));
              }
            }
          } else {
            var moduleBox = await Hive.openBox('moduleBox');
            var datamodule = await moduleBox.get(salesid);
            await moduleBox.close();
            List<Module> datamoduleconv = <Module>[];
            for (var i = 0; i < datamodule.length; i++) {
              datamoduleconv.add(datamodule[i]);
            }
            moduleList.clear();
            for (var i = 0; i < datamoduleconv.length; i++) {
              moduleList.add(datamoduleconv[i]);
            }
              var idx = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order"));
              if(idx != -1){
                moduleList.removeAt(idx);
              }  
          }
        } else {
            var moduleBox = await Hive.openBox('moduleBox');
            var datamodule = await moduleBox.get(salesid);
            await moduleBox.close();
            List<Module> datamoduleconv = <Module>[];
            for (var i = 0; i < datamodule.length; i++) {
              datamoduleconv.add(datamodule[i]);
            }
            moduleList.clear();
            for (var i = 0; i < datamoduleconv.length; i++) {
              moduleList.add(datamoduleconv[i]);
            }
            var idx = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order"));
            if(idx != -1){
              moduleList.removeAt(idx);
            }  
        }
      } catch (e) {
        try {
          var moduleBox = await Hive.openBox('moduleBox');
          var datamodule = await moduleBox.get(salesid);
          await moduleBox.close();
          List<Module> datamoduleconv = <Module>[];
          for (var i = 0; i < datamodule.length; i++) {
            datamoduleconv.add(datamodule[i]);
          }
          moduleList.clear();
          for (var i = 0; i < datamoduleconv.length; i++) {
            moduleList.add(datamoduleconv[i]);
          }
          var idx = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order"));
          if(idx != -1){
            moduleList.removeAt(idx);
          }
        // ignore: empty_catches
        } catch (e) {
          
        }
        forcedownload = true;
        Utils().showDialogSingleButton(keyhome.currentContext!,"Error" ,"Gagal Load Data ! ${e.toString()}","error.json",(){Get.back();});
      } finally{
        isdoneloading.value = true;
      }
      
  }

  unduhModuleAccess() async{
    try {
      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      String urlAPI = arrConnTest[1];
      if(!isConnected){
        for (var i = 0; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
        }
        String salesid = await Utils().getParameterData('sales');
        await Utils().managedevicestatebox('open');
        var datastatebox = await devicestatebox.get(salesid);
        await Utils().managedevicestatebox('close');
        if(datastatebox != null){
          await syncCustomerData(cekstatedevice);
          try {
            Navigator.pop(keybanner.currentContext!);
          // ignore: empty_catches
          } catch (e) {
            
          }
          Utils().showDialogSingleButton(keyhome.currentContext!,"Oops, Terjadi kesalahan" ,"Tidak Ada koneksi internet !","error.json",(){Get.back();});
          return;
        }
        isdoneloading.value = true;
          try {
            Navigator.pop(keybanner.currentContext!);
          // ignore: empty_catches
          } catch (e) {
            
          }
          Utils().showDialogSingleButton(keyhome.currentContext!,"Oops, Terjadi kesalahan" ,"Tidak Ada koneksi internet !","error.json",(){Get.back();});
          return;
      } else {
        print("here");
        moduleList.clear();
        String salesid = await Utils().getParameterData('sales');
        final encryptedParam = await Utils.encryptData(salesid);
        final result = await ApiClient().getData(urlAPI, "/datadev?sales_id=$encryptedParam");
        var data = jsonDecode(result.toString());
        // var sizejson = await Utils().calculateJsonSize(data);
        // print("1. module access : ${sizejson.toString()}");
        data["AppModule"].map((item) {
          moduleList.add(Module.from(item));
        }).toList();

        var moduleBox = await Hive.openBox('moduleBox');
        await moduleBox.delete(salesid);
        await moduleBox.put(salesid, moduleList);
        await moduleBox.close();

        if(!Hive.isBoxOpen("BranchInfoBox")){
          branchinfobox = await Hive.openBox('BranchInfoBox');
        }
        await branchinfobox.delete(salesid);
        await branchinfobox.put(salesid, data['BranchInfo']);
        await branchinfobox.close();
        progressdownload[0] = 'ok';
        var idx = moduleList.indexWhere((element) => element.moduleID.contains("Taking Order"));
        if(idx != -1){
          versimodulvendor = moduleList[idx].version;
          ordermodulvendor = moduleList[idx].orderNumber;
          moduleList.removeAt(idx);
          await loginApiVendor();
          await Utils().managetokenbox('open');
          var tokendata = await tokenbox.get(salesid);
          await Utils().managetokenbox('close');
          if (tokendata != null) {
            getStateUnduhUlang();
          } else {
            for (var i = 1; i < progressdownload.length; i++) {
              await Future.delayed(Duration(milliseconds: 250));
              progressdownload[i] = 'bad';
            }
            isdoneloading.value = true;
            try {
            Navigator.pop(keybanner.currentContext!);
            // ignore: empty_catches
            } catch (e) {
              
            }
          }
        } else {
          for (var i = 1; i < progressdownload.length; i++) {
            await Future.delayed(Duration(milliseconds: 250));
            progressdownload[i] = 'ok';
          }
          isdoneloading.value = true;
          try {
            Navigator.pop(keybanner.currentContext!);
          // ignore: empty_catches
          } catch (e) {
            
          }
        }
      }
    } on SocketException{
      for (var i = 0; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
        }
        String salesid = await Utils().getParameterData('sales');
        await Utils().managedevicestatebox('open');
        var datastatebox = await devicestatebox.get(salesid);
        await Utils().managedevicestatebox('close');
        if(datastatebox != null){
          await syncCustomerData(cekstatedevice);
          try {
            Navigator.pop(keybanner.currentContext!);
          // ignore: empty_catches
          } catch (e) {
            
          }
          Utils().showDialogSingleButton(keyhome.currentContext!,"Oops, Terjadi kesalahan" ,"Tidak Ada koneksi internet !","error.json",(){Get.back();});
          return;
        }
      isdoneloading.value = true;
      for (var i = 0; i < progressdownload.length; i++) {
        await Future.delayed(Duration(milliseconds: 250));
        progressdownload[i] = 'bad';
      }
      try {
        Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
      } catch (e) {
            
      }
    } catch (e) {
      for (var i = 0; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
      }
      String salesid = await Utils().getParameterData('sales');
      await Utils().managedevicestatebox('open');
      var datastatebox = await devicestatebox.get(salesid);
      await Utils().managedevicestatebox('close');
      if(datastatebox != null){
          await syncCustomerData(cekstatedevice);
          try {
            Navigator.pop(keybanner.currentContext!);
          // ignore: empty_catches
          } catch (e) {
            
          }
          Utils().showDialogSingleButton(keyhome.currentContext!,"Gagal unduh data" ,e.toString(),"error.json",(){Get.back();});
          return;
      }
      isdoneloading.value = true;
      for (var i = 0; i < progressdownload.length; i++) {
        await Future.delayed(Duration(milliseconds: 250));
        progressdownload[i] = 'bad';
      }
      try {
        Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
      } catch (e) {
            
      }
      Utils().showDialogSingleButton(keyhome.currentContext!,"Gagal unduh data" ,e.toString(),"error.json",(){Get.back();});
    }
    
  }

  getStateUnduhUlang() async {
    try {
      // DateTime now = DateTime.now();
      // print('start time: $now');
      var connTest = await ApiClient().checkConnection();
      var arrConnTest = connTest.split("|");
      bool isConnected = arrConnTest[0] == 'true';
      if(!isConnected){
      //tidak ada koneksi tidak bisa update
        for (var i = 1; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'bad';
        }
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        isdoneloading.value = true;
        return;
      }
      String urlAPI = arrConnTest[1];
      String salesid = await Utils().getParameterData('sales');
      String branchcode = salesid.toString().substring(0,3);
      final result = await ApiClient().getData(urlAPI, "/getstate?branch=$branchcode");
      jsonstate = jsonDecode(result);
      await Utils().managedevicestatebox('open');
      var datastatebox = await devicestatebox.get(salesid);
      await Utils().managedevicestatebox('close');
      if(datastatebox != null){
        for (var i = 0; i < jsonstate['datastate'].length; i++) {
          for (var k = 0; k < datastatebox['data']['datastate'].length; k++) {
            if(datastatebox['data']['datastate'][k]['name'] == jsonstate['datastate'][i]['name'] && datastatebox['data']['datastate'][k]['Value'] != jsonstate['datastate'][i]['Value']){
              if(AppConfig().vendorstate.toLowerCase() == datastatebox['data']['datastate'][k]['name'].toString().toLowerCase()){
                //perlu update
                // Navigator.pop(keybanner.currentContext!);
                unduhDataRoute();
                return;
              }
            }
          }
        }
        //sudah terupdate
        if(forcedownload){
          unduhDataRoute();
          return;
        }
        await syncCustomerData(redownload);
        for (var i = 1; i < progressdownload.length; i++) {
          await Future.delayed(Duration(milliseconds: 250));
          progressdownload[i] = 'ok';
        }
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        Utils().showDialogSingleButton(keyhome.currentContext!,"Informasi" ,"Semua data telah diupdate !","done.json",(){Get.back();});
        return;
      }
      //belum ada data state, perlu update
      unduhDataRoute();
      return;
    } catch (e) {
      //error tidak bisa update
      for (var i = 1; i < progressdownload.length; i++) {
        await Future.delayed(Duration(milliseconds: 250));
        progressdownload[i] = 'bad';
      }
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
      isdoneloading.value = true;
      return;
    }
  }

  updateState() async{
    try {
      bool allok = true;
      String salesid = await Utils().getParameterData('sales');
      for (var i = 0; i < progressdownload.length; i++) {
        if(progressdownload[i] != 'ok'){
          allok = false;
          break;
        }
      }
      if(allok){
        DateTime now = DateTime.now();
        String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
        print('end time: $now');
        await Utils().managedevicestatebox('open');
        await devicestatebox.delete(salesid);
        var makejson = {
          "data" : jsonstate, "lastdownload" : date
        };
        await devicestatebox.put(salesid, makejson);
        await Utils().managedevicestatebox('close');
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
        isdoneloading.value = true;
        forcedownload = false;
        Utils().showDialogSingleButton(keyhome.currentContext!,"Informasi" ,"Semua data telah diupdate !","done.json",(){Get.back();});
        return;
      }
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
      isdoneloading.value = true;
    } catch (e) {
      forcedownload = true;
      isdoneloading.value = true;
      try {
        Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
      } catch (e) {
          
      }
    }
      
  }

  cekDeviceState() async {
    try {
        isdoneloading.value = false;
        await cleanPreviousUserData();
        String salesid = await Utils().getParameterData('sales');
        // await Backgroundservicecontroller().createLogTes(salesid);
        await Utils().managedevicestatebox('open');
        // await Backgroundservicecontroller().createLogTes('openning box device');
        var datastatebox = await devicestatebox.get(salesid);
        // await Backgroundservicecontroller().createLogTes('reading box device');
        await Utils().managedevicestatebox('close');
        // await Backgroundservicecontroller().createLogTes('closing box device');
        if(datastatebox != null){
          if(Utils().isDateNotToday(Utils().formatDate(datastatebox['lastdownload']))){
            var connTest = await ApiClient().checkConnection();
            var arrConnTest = connTest.split("|");
            bool isConnected = arrConnTest[0] == 'true';
            if(!isConnected){
              syncCustomerData(cekstatedevice);
            } else {
              forcedownload = true;
              showLoadingBanner(keyhome.currentContext!);
              unduhModuleAccess();
            }
          } else {
            syncCustomerData(cekstatedevice);
          }
        }else {
          // await Backgroundservicecontroller().createLogTes('trying to show banner');
          showLoadingBanner(keyhome.currentContext!);
          // await Backgroundservicecontroller().createLogTes('trying to download module');
          unduhModuleAccess();
        }
    } catch (e) {
      isdoneloading.value = true;
      forcedownload = true;
      Utils().showDialogSingleButton(keyhome.currentContext!,"Error" ,"Gagal Cek State Gadget ! ${e.toString()}","error.json",(){Get.back();});
    }
      
  }

  processFile(bool download,String vendor) async {
    String productdir = AppConfig().productdir;
    String informasiconfig = AppConfig().informasiconfig;
    print("download");
    //download not using await because efficiency time for parallel download
    String branchuser = "";
    String warnauser = "";
    String areauser = "";
    await Utils().managebranchinfobox('open');
    var databranch = await branchinfobox.get(await Utils().getParameterData("sales"));
    try {
      branchuser = databranch[0]['branch'];
      warnauser = databranch[0]['color'];
      areauser = databranch[0]['area'];
    // ignore: empty_catches
    } catch (e) {
      
    }
    await Utils().managebranchinfobox('close');

    if (await File('$productdir/${vendor.toLowerCase()}/$informasiconfig').exists()) {
        var res = await File('$productdir/${vendor.toLowerCase()}/$informasiconfig').readAsString();
        var ls = const LineSplitter();
        var tlist = ls.convert(res);
        for (var i = 0; i < tlist.length; i++) {
          var undollar = tlist[i].split('\$');
          var unpipelined = undollar[0].split("|");
          if(unpipelined[0] == AppConfig().forall){
            //untuk all cabang
            isThereAnyPeriod(undollar,download,vendor);
          } else if(unpipelined[0] == AppConfig().forbranch){
              //untuk cabang tertentu
              for (var j = 1; j < unpipelined.length; j++) {
                if(unpipelined[j] == branchuser){
                  isThereAnyPeriod(undollar,download,vendor);
                }
              }
          } else if(unpipelined[0] == AppConfig().forcolor){
              //untuk cabang dengan warna tertentu
              for (var j = 1; j < unpipelined.length; j++) {
                if(unpipelined[j] == warnauser){
                  isThereAnyPeriod(undollar,download,vendor);
                }
              }  
          } else if(unpipelined[0] == AppConfig().forarea){
              //untuk cabang dengan area tertentu
              for (var j = 1; j < unpipelined.length; j++) {
                if(unpipelined[j] == areauser){
                  isThereAnyPeriod(undollar,download,vendor);
                }
              }
          }
        }
      }
  }

  isThereAnyPeriod(List<String> stringdata,bool download, String vendor){
    var filedir = stringdata[1];
    if(stringdata.length == 2){
      //tanpa periode
      if(download){
        downloadUsingDir(filedir,vendor);
      }
    } else if (stringdata.length == 3){
      //terdapat periode
      if(Utils().isinperiod(stringdata[2])){
        if(download){
          downloadUsingDir(filedir,vendor);
        }
      }
    }
  }

  downloadUsingDir(String directoryfile,String vendor) async {
    var pathh = directoryfile.split('/');
    var dir = "";
    for (var i = 0; i < pathh.length - 1; i++) {
      dir =  "$dir/${pathh[i]}";
    }
    var fname = pathh[pathh.length - 1];
    await ApiClient().downloadfiles(dir, fname,vendor);
  }
  
  Future<void> downloadConfigFile(String url) async {
    try {
      String productdir = AppConfig().productdir;
      String informasiconfig = AppConfig().informasiconfig;
      String vendorname = "";
      for (var m = 0; m < vendorlistunduhulang.length; m++) {
        vendorname = vendorlistunduhulang[m].name.toLowerCase();
        // Create a folder if it doesn't exist
        Directory directory = Directory('$productdir/${vendorname.toLowerCase()}/');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        var connTest = await ApiClient().checkConnection();
        var arrConnTest = connTest.split("|");
        bool isConnected = arrConnTest[0] == 'true';
        String urlAPI = arrConnTest[1];
        if (!isConnected) {
          progressdownload[4] = 'bad';
          if (await File('$productdir/${vendorname.toLowerCase()}/$informasiconfig').exists()) {
            processFile(false,vendorname);
          }
        } else {
          // Create the file path
          String filePath = '$productdir/${vendorname.toLowerCase()}/$informasiconfig';

          // Download the file
          final response = await http.get(Uri.parse('$urlAPI/$url?vendor=$vendorname'));

          if (response.statusCode == 200) {
            // Write the file
            try {
              var resp = jsonDecode(response.body);
              if(resp['error'] == 'vendor tidak ditemukan'){
                if (await File('$productdir/${vendorname.toLowerCase()}/$informasiconfig').exists()) {
                  processFile(true,vendorname);
                }
              }
            } catch (e) {
              File file = File(filePath);
              await file.writeAsBytes(response.bodyBytes);
              processFile(true,vendorname);
            }
          } else {
            progressdownload[4] = 'bad';
            if (await File('$productdir/${vendorname.toLowerCase()}/$informasiconfig').exists()) {
              processFile(true,vendorname);
            }
          }
        }
      }
      if(progressdownload[4] != 'bad'){
        progressdownload[4] = 'ok';
      }
      // Navigator.pop(keybanner.currentContext!);
      DateTime now = DateTime.now();
      print('end time: $now');
      updateState();
      return;
    } catch (e) {
      progressdownload[4] = 'bad';
      isdoneloading.value = true;
        try {
          Navigator.pop(keybanner.currentContext!);
        // ignore: empty_catches
        } catch (e) {
          
        }
    }
  }

  cleanPreviousUserData() async{
      try {
      var moduleBox = await Hive.openBox('moduleBox');
      List<dynamic> keys = moduleBox.keys.toList();
      String salesid = await Utils().getParameterData("sales");
      if(keys.isNotEmpty){
        bool isneedtoclean = false;
        for (var i = 0; i < keys.length; i++) {
          if(salesid != keys[i]){
              isneedtoclean = true;
              break;
          }
        }
        if(isneedtoclean == true){
            await moduleBox.deleteAll(keys); //clean module box
            await moduleBox.close();
            keys.clear();

            await Utils().managevendorbox('open'); //clean vendorbox
            keys = vendorBox.keys.toList();
            if(keys.isNotEmpty){
              await vendorBox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managevendorbox('close');
            
            await Utils().managebranchinfobox('open'); //clean branchinfobox
            keys = branchinfobox.keys.toList();
            if(keys.isNotEmpty){
              await branchinfobox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managebranchinfobox('close');

            await Utils().managecustomerbox('open'); //clean customerbox
            keys = customerBox.keys.toList();
            if(keys.isNotEmpty){
              await customerBox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managecustomerbox('close');

            await Utils().manageoutstandingbox('open'); //clean outstandingbox
            keys = outstandingBox.keys.toList();
            if(keys.isNotEmpty){
              await outstandingBox.deleteAll(keys);
            }
            keys.clear();
            await Utils().manageoutstandingbox('close');

            await Utils().managepiutangbox('open'); //clean piutangBox
            keys = piutangBox.keys.toList();
            if(keys.isNotEmpty){
              await piutangBox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managepiutangbox('close');

            await Utils().manageshipbox('open'); //clean shiptobox
            keys = shiptobox.keys.toList();
            if(keys.isNotEmpty){
              await shiptobox.deleteAll(keys);
            }
            keys.clear();
            await Utils().manageshipbox('close');

            await Utils().managetokenbox('open'); //clean tokenbox
            keys = tokenbox.keys.toList();
            if(keys.isNotEmpty){
              await tokenbox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managetokenbox('close');

            await Utils().managebankbox('open'); //clean bankbox
            keys = bankbox.keys.toList();
            if(keys.isNotEmpty){
              await bankbox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managebankbox('close');

            await Utils().managepaymentmethodsbox('open'); //clean paymentMethodsBox
            keys = paymentMethodsBox.keys.toList();
            if(keys.isNotEmpty){
              await paymentMethodsBox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managepaymentmethodsbox('close');

            await Utils().managedevicestatebox('open'); //clean devicestatebox
            keys = devicestatebox.keys.toList();
            if(keys.isNotEmpty){
              await devicestatebox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managedevicestatebox('close');

            await Utils().manageitemvendorbox('open'); //clean itemvendorbox
            keys = itemvendorbox.keys.toList();
            if(keys.isNotEmpty){
              await itemvendorbox.deleteAll(keys);
            }
            keys.clear();
            await Utils().manageitemvendorbox('close');

            await Utils().managemasteritembox('open'); //clean masteritembox
            keys = masteritembox.keys.toList();
            if(keys.isNotEmpty){
              await masteritembox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managemasteritembox('close');

            await Utils().managemastervendorbox('open'); //clean mastervendorbox
            keys = mastervendorbox.keys.toList();
            if(keys.isNotEmpty){
              await mastervendorbox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managemastervendorbox('close');

            await Utils().managemasteritemvendorbox('open'); //clean masteritemvendorbox
            keys = masteritemvendorbox.keys.toList();
            if(keys.isNotEmpty){
              await masteritemvendorbox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managemasteritemvendorbox('close');

            await Utils().manageboxPembayaranState('open'); //clean boxPembayaranState
            keys = boxPembayaranState.keys.toList();
            if(keys.isNotEmpty){
              await boxPembayaranState.deleteAll(keys);
            }
            keys.clear();
            await Utils().manageboxPembayaranState('close');

            await Utils().managestatePenjualanbox('open'); //clean statePenjualanbox
            keys = statePenjualanbox.keys.toList();
            if(keys.isNotEmpty){
              await statePenjualanbox.deleteAll(keys);
            }
            keys.clear();
            await Utils().managestatePenjualanbox('close');
        }
      }
      } catch (e) {
        //failed to delete previous data
      }
  }

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() {
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    throw UnimplementedError();
  }

}
