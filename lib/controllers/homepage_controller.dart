import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/tools/service.dart';

class HomepageController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var configData = "".obs;

  final txtServerIPController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    txtServerIPController.text = AppConfig.publicUrl;
    // getConfigData();
  }

  @override
  void onClose() {
    super.onClose();
    txtServerIPController.dispose();
  }

  // Future<String> getConfigData() async {
  //   isLoading(true);
  //   isError(false);
  //   try {
  //     final result = await ApiClient().getData("/config?app=quiz");
  //     var data = jsonDecode(result.toString());
  //     configData.value = data[0]["Value"].toString();

  //     isLoading(false);
  //     isError(false);
  //     Get.offAndToNamed(RouteName.homepage);
  //   } catch(e) {
  //     isLoading(false);
  //     isError(true);
  //     errorMessage(e.toString());
  //   }
  //   return configData.value;
  // }
}