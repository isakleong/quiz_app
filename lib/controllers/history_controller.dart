import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/quiz_history.dart';
import 'package:sfa_tools/tools/service.dart';
import 'package:sfa_tools/tools/utils.dart';

class HistoryController extends GetxController with StateMixin {
  var errorMessage = "".obs;
  var quizHistoryModel = <QuizHistory>[].obs;
  var filterQuizHistoryModel = <QuizHistory>[].obs;

  var isLoading = false.obs;

  var selectedFilter = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();

    final salesIdParams = Get.find<SplashscreenController>().salesIdParams;

    selectedFilter.clear();
    selectedFilter.add(false);
    selectedFilter.add(false);
    selectedFilter.add(true);

    getHistoryData(salesIdParams.value, selectedFilter);
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

    List<QuizHistory> tempQuizHistoryModel = [];

    for(int i=0; i<quizHistoryModel.length; i++) {
      if(selectedFilter[0]){
        if(quizHistoryModel[i].salesID.toLowerCase().contains("c100") || quizHistoryModel[i].salesID.toLowerCase().contains("c200") || quizHistoryModel[i].salesID.toLowerCase().contains("c300")) {
          tempQuizHistoryModel.add(quizHistoryModel[i]);
        }
      } else if(selectedFilter[1]) {
        if(quizHistoryModel[i].salesID.toLowerCase().contains("s")) {
          tempQuizHistoryModel.add(quizHistoryModel[i]);
        }
      } else if(selectedFilter[2]) {
        if(!quizHistoryModel[i].salesID.toLowerCase().contains("s") && !quizHistoryModel[i].salesID.toLowerCase().contains("c100") && !quizHistoryModel[i].salesID.toLowerCase().contains("c200") && !quizHistoryModel[i].salesID.toLowerCase().contains("c300")) {
          tempQuizHistoryModel.add(quizHistoryModel[i]);
        }
      }
    }
    filterQuizHistoryModel.clear();
    filterQuizHistoryModel.addAll(tempQuizHistoryModel);
  }

  getHistoryData(String params, List<bool> paramsFilter) async {
    isLoading(true);
    change(null, status: RxStatus.loading());
    quizHistoryModel.clear();

    bool isConnected = await ApiClient().checkConnection();
    if(isConnected) {
      try {
        final encryptedParam = await Utils.encryptData(params);

        var result = await ApiClient().getData("/quiz/history?sales_id=$encryptedParam");
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

            List<QuizHistory> tempQuizHistoryModel = [];

            if(paramsFilter[0]) {
              for(int i=0; i<quizHistoryModel.length; i++) {
                if(quizHistoryModel[i].salesID.toLowerCase().contains("c100") || quizHistoryModel[i].salesID.toLowerCase().contains("c200") || quizHistoryModel[i].salesID.toLowerCase().contains("c300")) {
                  tempQuizHistoryModel.add(quizHistoryModel[i]);
                }
              }  
            } else if(paramsFilter[1]) {
              for(int i=0; i<quizHistoryModel.length; i++) {
                if(quizHistoryModel[i].salesID.toLowerCase().contains("s")) {
                  tempQuizHistoryModel.add(quizHistoryModel[i]);
                }
              }  
            } else if(paramsFilter[2]) {
              for(int i=0; i<quizHistoryModel.length; i++) {
                if(!quizHistoryModel[i].salesID.toLowerCase().contains("s") && !quizHistoryModel[i].salesID.toLowerCase().contains("c100") && !quizHistoryModel[i].salesID.toLowerCase().contains("c200") && !quizHistoryModel[i].salesID.toLowerCase().contains("c300")) {
                  tempQuizHistoryModel.add(quizHistoryModel[i]);
                }
              }  
            }

            filterQuizHistoryModel.clear();
            filterQuizHistoryModel.addAll(tempQuizHistoryModel);

            isLoading(false);
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
    } else {
      errorMessage(Message.errorConnection);
      change(null, status: RxStatus.error(errorMessage.value));
    }
  }
}