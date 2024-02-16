import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/couponmab.dart';
import 'package:sfa_tools/screens/coupon_mab/approval.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';

class CouponMABController extends GetxController with StateMixin {
  var errorMessage = "".obs;

  RxList<CouponMABData> listDataMAB = <CouponMABData>[].obs;

  @override
  void onInit() {
    super.onInit();

    final salesIdParams = Get.find<SplashscreenController>().salesIdParams;

    fetchData(salesIdParams.value);
  }

  fetchData(String params) async {
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
              listDataMAB.add(CouponMABData.fromJson(item));
            }).toList();

            var dataMABBox = await Hive.openBox('dataMABBox');
            await dataMABBox.clear();
            await dataMABBox.addAll(listDataMAB);
            await dataMABBox.close();

          } else {
            change(null, status: RxStatus.empty());
          }

        } else {
          errorMessage.value = result.toString();
          change(null, status: RxStatus.error(errorMessage.value));
        }
      } catch (e) {
        errorMessage.value = e.toString();
        change(null, status: RxStatus.error(errorMessage.value));
      }

    } else {
      errorMessage(Message.errorConnection);
      change(null, status: RxStatus.error(errorMessage.value));
    }

    change(null, status: RxStatus.success());
  }
}