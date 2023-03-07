import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/models/quiz.dart';


// ignore: must_be_immutable
class QuizPage extends GetView<QuizController>{
  QuizPage({super.key});

  final quizController = Get.find<QuizController>();
  
  List<Widget> questionWidget = [];

  finishQuiz() {
    List<int> arrInvalidQuestion = [];
    bool isValid = true;
    for(int i=0; i<quizController.quizModel.length; i++) {
      isValid = true;
      if(quizController.quizModel[i].answerSelected < 0) {
        isValid = false;
        arrInvalidQuestion.add(i+1);
      }
    }

    String strInvalidQuestion = arrInvalidQuestion.join(", ");

    if(arrInvalidQuestion.isEmpty) {
      Get.dialog(
        AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset('assets/images/confirm.png', width: 220, height: 220),
                const SizedBox(height: 30),
                const Text('Apakah Anda yakin ingin mengumpulkan kuis?', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
                ),
                child: const Text('Tidak', style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
                ),
                child: const Text('Ya, Kumpul', style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  Get.back();
                  quizSummary();
                },
              ),
            ),
          ],
        ),
      );

    } else {
      Get.dialog(
        AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset('assets/images/warning.png', width: 220, height: 220),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Gagal mengumpulkan kuis, pastikan Anda sudah menjawab semua pertanyaan kuis yang disediakan.\n\n',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: 'Pertanyaan yang belum dijawab adalah nomor :\n$strInvalidQuestion', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
                ),
                child: const Text('Ok', style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
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

    print("total score $score");
    print("total target ${arrTarget[0]}");

    await quizController.submitQuiz();

    if(score >= int.parse(arrTarget[0])) {
      Get.dialog(
        AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset('assets/images/fireworks.png', width: 250, height: 250),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Selamat! Anda dinyatakan ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: 'LULUS', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' kuis periode ini'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
                ),
                child: const Text('Ok', style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  Get.back();
                  quizController.isReset(!(quizController.isReset.value));
                  // Get.until((route) => Get.currentRoute == RouteName.dashboard);
                },
              ),
            ),
          ],
        ),
      );

    } else {
      Get.dialog(
        AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset('assets/images/failed.png', width: 220, height: 220),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Mohon maaf, Anda dinyatakan ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: 'BELUM LULUS', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' kuis periode ini, silakan mencoba mengerjakan ulang di esok hari'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
                ),
                child: const Text('Ok', style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  // await quizController.retryQuiz();
                  quizController.isReset(!(quizController.isReset.value));
                  Get.back();
                  Get.offNamed(RouteName.dashboard);
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  int value = -1;
  // ignore: non_constant_identifier_names
  Widget CustomRadioButton(String text, int index) {
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
          foregroundColor: AppConfig.darkGreenColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(color: (quizController.quizModel[quizController.currentQuestion.value].answerSelected == index) ? AppConfig.mainGreenColor : Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: TextStyle(
              color: (quizController.quizModel[quizController.currentQuestion.value].answerSelected == index) ? AppConfig.mainGreenColor : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
        quizController.resetQuestion();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppConfig.lightGreenColor,
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
                      : AppConfig.darkGreenColor,
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
                                maxHeight: MediaQuery.of(context).size.height / 4 * 3,
                                minHeight: MediaQuery.of(context).size.height / 3,
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15, bottom: 20),
                                    child: Text('Pilih Soal No', style: TextStyle(fontSize: 16)),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        spacing: 20,
                                        runSpacing: 15,
                                        children: List.generate(quizController.quizModel.length, (index) => InkWell(
                                          onTap: () {
                                            Get.back();
                                            quizController.updateIndex(index);
                                          },
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: index == quizController.currentQuestion.value ? AppConfig.darkGreenColor : Colors.white,
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: index == quizController.currentQuestion.value ? Colors.white : Colors.black,
                                                fontWeight: FontWeight.bold, fontSize: 20
                                              )
                                            ),
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
                        );
                      }, 
                      icon: const Icon(FontAwesomeIcons.circleArrowUp, size: 30,),
                    ),
                    Obx(() => Text('${quizController.currentQuestion.value+1} / ${quizController.quizModel.length}', style: const TextStyle(fontSize: 16)))
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
                      backgroundColor: AppConfig.darkGreenColor,
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
            builder: (context, constraints) => Column(
              children: [
                Container(
                  height: constraints.maxHeight * .45,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Obx(() =>Text(quizController.quizModel[quizController.currentQuestion.value].question, style: const TextStyle(fontSize: 20))),
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
                          return CustomRadioButton("${quizController.quizModel[quizController.currentQuestion.value].answerList[index]} -- ${quizController.quizModel[quizController.currentQuestion.value].correctAnswerIndex}", index);
                        }),
                      ), 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Triangle extends StatelessWidget {
  const _Triangle({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ShapesPainter(color),
      child: Container(
        height: 40,
        width: 40,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 16),
            child: Icon(Icons.check, color: Colors.white, size: 15),
          )
        )
      )
    );
  }
}

class _ShapesPainter extends CustomPainter {
  final Color color;
  _ShapesPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}