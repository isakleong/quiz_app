import 'dart:convert';

import 'package:get/get.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/tools/service.dart';

class ConfigController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var configData = "".obs;

  @override
  void onInit() {
    super.onInit();
    getConfigData();
  }

  Future<String> getConfigData() async {
    isLoading(true);
    try {
      final result = await ApiClient().getData("/confdsdig?app=quiz");
      var data = jsonDecode(result.toString());
      configData.value = data[0]["Value"].toString();
      isLoading(false);
      isError(false);

      Get.offAndToNamed(RouteName.dashboard);

    } catch(e) {
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
      throw Exception(e);
    }
    return "true";
  }
}