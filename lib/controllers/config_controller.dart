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
    isError(false);
    try {
      // final dio = Dio(
      //   BaseOptions(baseUrl: AppConfig.baseUrl)
      // );

      final result = await ApiClient().getData("/config?app=quiz");
      var data = jsonDecode(result.toString());
      configData.value = data[0]["Value"].toString();

      isLoading(false);
      isError(false);
      Get.offAndToNamed(RouteName.dashboard);

      // // var url = Uri.https('https://link.tirtakencana.com/QuizApp/public/api', '/config?app=quiz');
      // var response = await http.get(Uri.parse("http://link.tirtakencana.com/QuizApp/public/api/config?app=quiz"));
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // var data = jsonDecode(response.body.toString());
      // configData.value = data[0]["Value"].toString();

      // if(response.statusCode == 200) {
      //   isLoading(false);
      //   isError(false);
      //   Get.offAndToNamed(RouteName.dashboard);
      // } else {
      //   isLoading(false);
      //   isError(true);
      //   errorMessage(response.body);  
      // }
    } catch(e) {
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
      // throw Exception(e);
    }
    return configData.value;
  }
}