import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/couponmab.dart';
import 'package:sfa_tools/models/servicebox.dart';
import 'package:sfa_tools/screens/coupon_mab/approval.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/dialog.dart';
import 'package:sfa_tools/widgets/textview.dart';

class CouponMABController extends GetxController with StateMixin {
  var errorMessage = "".obs;

  var isLoading = false.obs;
  
  var selectedFilter = <bool>[].obs;

  var filterlistDataMAB = <CouponMABData>[].obs;
  var listDataMAB = <CouponMABData>[].obs;

  @override
  void onInit() {
    super.onInit();

    final salesIdParams = Get.find<SplashscreenController>().salesIdParams;

    selectedFilter.clear();
    selectedFilter.add(true);
    selectedFilter.add(false);

    fetchData(salesIdParams.value, selectedFilter);
  }

  applyFilter(int index) {
    for (int i=0; i<selectedFilter.length; i++) {
      if (i == index) {
        selectedFilter[i] = true;
      } else {
        selectedFilter[i] = false;
      }
    }
    update();

    List<CouponMABData> tempData = [];

    for(int i=0; i<listDataMAB.length; i++) {
      if(selectedFilter[0]){
        if(listDataMAB[i].jenis.toString().toLowerCase().contains("mab") || listDataMAB[i].jenis.toString() == null) {
          tempData.add(listDataMAB[i]);
        }
      } else if(selectedFilter[1]) {
        if(listDataMAB[i].jenis.toString().toLowerCase().contains("karyawan toko")) {
          tempData.add(listDataMAB[i]);
        }
      }
    }
    filterlistDataMAB.clear();
    filterlistDataMAB.addAll(tempData);
  }

  fetchData(String params, List<bool> paramsFilter) async {
    isLoading(true);
    change(null, status: RxStatus.loading());

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    if(isConnected) {
      try {
        final encryptedParam = await Utils.encryptData(params);
        final encodeParam = Uri.encodeComponent(encryptedParam);

        var result = await ApiClient().getData(urlAPI, "/mab?sales_id=$encodeParam");
        bool isValid = Utils.validateData(result.toString());

        if(isValid) {
          var data = jsonDecode(result.toString());

          if(data.length > 0) {
            listDataMAB.clear();

            data.map((item) {
              var tempItem = CouponMABData.fromJson(item);
              if(tempItem.jenis == null) {
                tempItem.jenis = "Kupon MAB";
              } else {
                tempItem.jenis = "Karyawan Toko";
              }
              listDataMAB.add(tempItem);
            }).toList();

            List<String?> listDocID = listDataMAB.map((data) => data.id).toList();
            String stateDataMAB = jsonEncode(listDocID);

            Box boxDataMAB = await Hive.openBox<ServiceBox>("boxDataMAB");
            await boxDataMAB.put("stateDataMAB",ServiceBox(value: stateDataMAB));
            boxDataMAB.close();

            List<CouponMABData> tempData = [];

            if(paramsFilter[0]) {  
              for(int i=0; i<listDataMAB.length; i++) {
                if(listDataMAB[i].jenis.toString().toLowerCase().contains("mab")) {
                  tempData.add(listDataMAB[i]);
                }
              }
            } else if(paramsFilter[1]) {
              for(int i=0; i<listDataMAB.length; i++) {
                if(listDataMAB[i].jenis.toString().toLowerCase().contains("karyawan toko")) {
                  tempData.add(listDataMAB[i]);
                }
              }
            }

            filterlistDataMAB.clear();
            filterlistDataMAB.addAll(tempData);

            isLoading(false);
            change(null, status: RxStatus.success());
          } else {
            isLoading(false);
            change(null, status: RxStatus.empty());
          }

        } else {
          isLoading(false);
          errorMessage.value = result.toString();
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } catch (e) {
        isLoading(false);
        errorMessage.value = e.toString();
        change(null, status: RxStatus.error(errorMessage.value));
      }

    } else {
      isLoading(false);
      errorMessage(Message.errorConnection);
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

  openSubmitDialog() {
    Get.dialog(
      AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/quiz-submit.json',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            const TextView(
              headings: "H3",
              text: "Mohon tunggu, sedang memproses data.",
              fontSize: 16,
              color: Colors.black
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  openSuccessDialog(bool status) {
    Get.dialog(
      AlertDialog(
        content: WillPopScope(
          onWillPop: () async{
            return false;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextView(
                headings: "H3",
                text: status == true ? "Data pengajuan berhasil diterima." : "Data pengajuan berhasil ditolak",
                fontSize: 16,
                color: Colors.black
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppConfig.darkGreen),
                onPressed: () async {
                  Get.back();
                  final salesIdParams = Get.find<SplashscreenController>().salesIdParams;
                  await fetchData(salesIdParams.value, selectedFilter);
                  filterlistDataMAB.refresh(); 
                },
                child: const TextView(headings: "H2", text: "ok", fontSize: 14, color: Colors.white,isCapslock: true),
              ),
        
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  openErrorSubmitDialog(String message) {
    appsDialog(
      type: "app_error",
      title: TextView(headings: "H3", text: message, fontSize: 16, color: Colors.black),
      isAnimated: true,
      leftBtnMsg: "Ok",
      leftActionClick: () {
        Get.back();
      }
    );
  }

  processApproval(String id, bool isApprove) async {
    final salesIdParams = Get.find<SplashscreenController>().salesIdParams;
    String salesId = salesIdParams.value;

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd H:m:s');
    String formattedDate = formatter.format(now);

    var connTest = await ApiClient().checkConnection();
    var arrConnTest = connTest.split("|");
    bool isConnected = arrConnTest[0] == 'true';
    String urlAPI = arrConnTest[1];

    var params =  {
      'sales_id': salesId,
      'id': id,
      'date': formattedDate,
      'status' : isApprove ? "acc" : "reject",
    };

    if (isConnected) {
      var bodyData = jsonEncode(params);
      var resultSubmit = await ApiClient().postData(
        urlAPI,
        '/mab/process',
        Utils.encryptData(bodyData),
        Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json"
          }
        )
      );

      var response = jsonDecode(resultSubmit);

      print(response.toString());
      print(response['code']);

      if(response['code'] == 200) {
        Get.back();
        Get.back();
        openSuccessDialog(isApprove);
      } else {
        openErrorSubmitDialog(response['msg']);
      }

    } else {
      errorMessage(Message.errorConnection);
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }

  approvalData(String id, bool isApprove) async {
    Get.back();
    openSubmitDialog();
    await processApproval(id, isApprove);
  }

}