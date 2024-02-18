import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/couponmab.dart';
import 'package:sfa_tools/screens/coupon_mab/approval.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';
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
    selectedFilter.add(false);

    fetchData(salesIdParams.value);
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

  fetchData(String params) async {
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

            // var dataMABBox = await Hive.openBox('dataMABBox');
            // await dataMABBox.clear();
            // await dataMABBox.addAll(listDataMAB);
            // await dataMABBox.close();

            List<CouponMABData> tempData = [];

            for(int i=0; i<listDataMAB.length; i++) {
              if(selectedFilter[0]){
                if(listDataMAB[i].jenis.toString().toLowerCase().contains("mab")) {
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
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/quiz-submit.json',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              const TextView(
                  headings: "H3",
                  text: Message.submittingQuiz,
                  fontSize: 16,
                  color: Colors.black),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  approvalData(String id, bool isApprove) async {
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
    } else {
      errorMessage(Message.errorConnection);
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }


}