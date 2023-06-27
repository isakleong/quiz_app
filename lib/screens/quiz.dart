import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/message_config.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/widgets/dialog.dart';
import 'package:quiz_app/widgets/textview.dart';

class QuizPage extends GetView<QuizController>{
  QuizPage({super.key});

  // final QuizController quizController = Get.find();
  final quizController = Get.find<QuizController>();

  finishQuiz() {
    List<int> arrInvalidQuestion = [];
    for(int i=0; i<quizController.quizModel.length; i++) {
      if(quizController.quizModel[i].answerSelected < 0) {
        arrInvalidQuestion.add(i+1);
      }
    }

    String strInvalidQuestion = arrInvalidQuestion.join(", ");

    if(arrInvalidQuestion.isEmpty) {
      appsDialog(
        type: "quiz_confirm",
        title: const TextView(headings: "H3", text: Message.confirmSubmitQuiz, fontSize: 16),
        isAnimated: true,
        isCancel: true,
        leftBtnMsg: "Tidak",
        rightBtnMsg: "Ya, Kumpul",
        leftActionClick: () {
          Get.back();
        },
        rightActionClick: () {
          Get.back();
          // quizSummary();
          quizController.submitQuiz();
        }
      );
    } else {
      appsDialog(
        type: "quiz_warning",
        title: Padding(
          padding: const EdgeInsets.all(10),
          child:  RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Gagal mengumpulkan kuis, pastikan Anda sudah menjawab semua pertanyaan kuis yang disediakan.\n\n',
              style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
              children: <TextSpan>[
                TextSpan(text: 'Pertanyaan yang belum dijawab adalah nomor :\n$strInvalidQuestion', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
              ],
            ),
          ),
        ),
        isAnimated: true,
        leftBtnMsg: "Ok",
        leftActionClick: () {
          Get.back();
        },
      );
    }
  }

  quizSummary() async {
    int score = 0;
    for(int i=0; i<quizController.quizModel.length; i++) {
      if(quizController.quizModel[i].answerSelected == quizController.quizModel[i].correctAnswerIndex) {
        score++;
      }
    }

    var target = ((quizController.quizTarget.value/100) * quizController.quizModel.length);
    var arrTarget = target.toString().split(".");

    if(score >= int.parse(arrTarget[0])) {
      quizController.isPassed(true);
    } else {
      quizController.isPassed(false);
    }
    await quizController.submitQuiz();

    if(score >= int.parse(arrTarget[0])) {
      quizController.isReset(!(quizController.isReset.value));

      appsDialog(
        type: "quiz_passed",
        title: Padding(
          padding: const EdgeInsets.all(10),
          child:  RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text: 'Selamat! Anda dinyatakan ',
              style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
              children: <TextSpan>[
                TextSpan(text: 'LULUS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                TextSpan(text: ' kuis periode ini', style: TextStyle(fontFamily: "Poppins")),
              ],
            ),
          ),
        ),
        isAnimated: true,
        leftBtnMsg: "Ok",
        leftActionClick: () {
          Get.back();
          Get.back();
        },
      );
    } else {
      quizController.isRestart(!(quizController.isRestart.value));
      
      appsDialog(
        type: "quiz_failed",
        title: Padding(
          padding: const EdgeInsets.all(10),
          child:  RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text: 'Mohon maaf, Anda dinyatakan ',
              style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
              children: <TextSpan>[
                TextSpan(text: 'BELUM LULUS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                TextSpan(text: ' kuis periode ini, silakan mencoba mengerjakan ulang kuisnya', style: TextStyle(fontFamily: "Poppins")),
              ],
            ),
          ),
        ),
        isAnimated: true,
        leftBtnMsg: "Ok",
        leftActionClick: () {
          Get.back();
          Get.back();
          // Get.offAllNamed(RouteName.quizDashboard);
        },
      );
    }
  }

  Widget customRadioButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: OutlinedButton(
        onPressed: () async {
          quizController.chooseQuestion(index);
          quizController.quizModel.refresh();

          var quizModelBox = await Hive.openBox<Quiz>('quizModelBox');
          quizModelBox.putAt(quizController.currentQuestion.value, quizController.quizModel[quizController.currentQuestion.value]);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConfig.darkGreen,
          backgroundColor: quizController.quizModel[quizController.currentQuestion.value].answerSelected == index ? AppConfig.lightSoftGreen : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(width: 1.3, color: (quizController.quizModel[quizController.currentQuestion.value].answerSelected == index) ? AppConfig.mainGreen : Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextView(
            headings: "H3",
            text: text, 
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () {
          quizController.resetQuestion();
          return Future.value(true);
        },
        child: controller.obx(
          onLoading: Scaffold(
            backgroundColor: AppConfig.mainGreen,
            body: Center(child: Lottie.asset('assets/lottie/loading-white.json', width: 60)),
          ),
          onError: (error) => Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/error.json',
                    width: Get.width*0.5,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextView(headings: "H3", text: "Error :\n${controller.errorMessage.value}", fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      quizController.getQuizData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.darkGreen,
                      padding: const EdgeInsets.all(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.history),
                        SizedBox(width: 10),
                        TextView(headings: "H3", text: "Coba Lagi", fontSize: 16, color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          (state) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppConfig.lightGrayishGreen, AppConfig.grayishGreen, AppConfig.softGreen, AppConfig.softCyan]
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 0,
                      color: Colors.white,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: () {
                            quizController.currentQuestion.value == 0 ? null : quizController.previousQuestion();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: quizController.currentQuestion.value == 0
                            ? Colors.grey
                            : AppConfig.darkGreen,
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.arrowLeft,
                            size: 25,
                            color:Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: (){
                              Get.bottomSheet(
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: Get.height / 4 * 3,
                                      minHeight: Get.height / 3,
                                    ),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 15, bottom: 10),
                                          child: TextView(headings: "H2", text: "Pilih Soal No", fontSize: 18, color: Colors.black),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 40),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: AppConfig.softRed,
                                                    maxRadius: 10,
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const TextView(headings: "H2", text: "Belum memilih jawaban", fontSize: 14, color: Colors.black),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: AppConfig.mainGreen,
                                                    maxRadius: 10,
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const TextView(headings: "H2", text: "Sudah memilih jawaban", fontSize: 14, color: Colors.black),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              spacing: 20,
                                              runSpacing: 30,
                                              children: List.generate(quizController.quizModel.length, (index) => InkWell(
                                                onTap: () {
                                                  Get.back();
                                                  quizController.updateIndex(index);
                                                },
                                                child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor: (quizController.quizModel[index].answerSelected != -1) ? AppConfig.darkGreen : AppConfig.softRed,
                                                  child: TextView(headings: "H2", text: "${index + 1}", fontSize: 20, color: Colors.white),
                                                ),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                backgroundColor: const Color(0xFFE0F6E3),
                                isScrollControlled: true, //set to true to automatically expand according to height dynamically
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60),
                                  )
                                ),
                              );
                            }, 
                            icon: const Icon(FontAwesomeIcons.circleArrowUp, size: 30,),
                          ),
                          Obx(() => TextView(headings: "H2", text: "${quizController.currentQuestion.value+1} / ${quizController.quizModel.length}", fontSize: 16, color: Colors.black))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: () {
                            quizController.currentQuestion.value == quizController.quizModel.length-1 ? finishQuiz() : quizController.nextQuestion();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConfig.darkGreen,
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: Icon(
                            quizController.currentQuestion.value == quizController.quizModel.length-1 ? FontAwesomeIcons.check : FontAwesomeIcons.arrowRight,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    children:[
                      Positioned(
                        top: 15,
                        left: 15,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConfig.darkGreen,
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(FontAwesomeIcons.arrowLeft, size: 25, color: Colors.white),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: constraints.maxHeight * .45,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            child: Obx(
                              () => SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: TextView(headings: "H3", text: quizController.quizModel[quizController.currentQuestion.value].question, fontSize: 18, color: Colors.black),
                              )
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: constraints.maxHeight, // will get by column
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                                )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                                child: Obx(() => ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: quizController.quizModel[quizController.currentQuestion.value].answerList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return customRadioButton("${quizController.quizModel[quizController.currentQuestion.value].answerList[index]} (CorrectAnswerIndex is: ${quizController.quizModel[quizController.currentQuestion.value].correctAnswerIndex})", index);
                                    // return customRadioButton(quizController.quizModel[quizController.currentQuestion.value].answerList[index], index);
                                  }),
                                ), 
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] 
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}