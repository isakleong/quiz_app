

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/models/quiz_history.dart';
import 'package:quiz_app/tools/service.dart';
import 'package:quiz_app/tools/utils.dart';

class HistoryController extends GetxController with StateMixin {
  var errorMessage = "".obs;
  var quizHistoryModel = <QuizHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    getHistoryData();
  }

  getHistoryData() async {
    change(null, status: RxStatus.loading());
    quizHistoryModel.clear();

    try {
      var result = await ApiClient().getData("/quiz/history?sales_id=00AC1A0103");
      bool isValid = Utils.validateData(result.toString());

      if(isValid) {
        var data = jsonDecode(result.toString());

        if(data.length > 0) {
          data.map((item) {
            quizHistoryModel.add(QuizHistory.from(item));
          }).toList();

          for(int i=0; i<quizHistoryModel.length; i++) {
            var formatter = DateFormat('yyyy-MM-dd H:m:s');
            DateTime dateTime = formatter.parse(quizHistoryModel[i].tanggal);
            formatter = DateFormat('dd-MM-yyyy HH:mm');
            String formattedDate = formatter.format(dateTime);
            quizHistoryModel[i].tanggal = formattedDate;
          }

          change(null, status: RxStatus.success());
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
  }
}