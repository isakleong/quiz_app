

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/models/quiz_history.dart';
import 'package:quiz_app/tools/service.dart';

class HistoryController extends GetxController with StateMixin {
  var errorMessage = "".obs;
  var quizHistoryModel = <QuizHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataHistory();
  }

  fetchDataHistory() async {
    change(null, status: RxStatus.loading());

    try {
      //fetch quiz history data
      var result = await ApiClient().getData("/quiz/history?sales_id=00AC1A0103");
      var data = jsonDecode(result.toString());
      data.map((item) {
        quizHistoryModel.add(QuizHistory.from(item));
      }).toList();

      for(int i=0; i<quizHistoryModel.length; i++) {
        var formatter = DateFormat('yyyy-MM-dd H:m:s');
        DateTime dateTime = formatter.parse(quizHistoryModel[i].tanggal);
        formatter = DateFormat('dd-MM-yyyy H:m');
        String formattedDate = formatter.format(dateTime);
        quizHistoryModel[i].tanggal = formattedDate;
      }

      print(data[0]);
      
    } catch(e) {
      print("masuk catch" );
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(errorMessage.value));
    }

    change(null, status: RxStatus.success());
  }


}