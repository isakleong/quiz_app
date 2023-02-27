import 'package:get/get.dart';

class QuizController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var configData = "".obs;
}