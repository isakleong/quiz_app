import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class StartQuiz extends GetView<QuizController>  {

  openDialog(String errorMessage) {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/error.json',
                width: 100,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Obx(() => Text(
                  "Error message :\n$errorMessage"
                  )
                )
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
              child: const Text('OK', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  exLoading() {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/loading.json',
                width: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children:[
          SvgPicture.asset(
            'assets/images/bg-starter.svg',
            fit: BoxFit.cover,
          ),
          controller.obx(
            (state) => CircularButton(),
            onLoading: Center(child: Lottie.asset('assets/lottie/loading.json', width: 60)),
            // onLoading: exLoading(),
            onEmpty: const Text('No data found'),
            onError: (error) => Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/error.json',
                      width: mediaWidth*0.5,
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text("Error :\n${controller.errorMessage.value}", style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        final QuizController quizController = Get.find();
                        quizController.fetchQuizData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.darkGreenColor,
                        padding: const EdgeInsets.all(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.history),
                          SizedBox(width: 10),
                          Text("Coba Lagi", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: ClipOval(
            child: Container(
              color: AppConfig.mainGreenColor,
              height: 250,
              width: 250,
            ),
          ),
        ),

        Center(
          child: Container(
            height: 230,
            width: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 10,
                style: BorderStyle.solid
              ),
            ),
            child: Material(
              color: AppConfig.mainGreenColor,
              shape: const CircleBorder(),
              child: InkWell(
                splashColor: AppConfig.lightGreenColor,
                customBorder: const CircleBorder(),
                onTap: () {
                  Get.offAndToNamed(RouteName.countdown);
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'MULAI',
                      style: TextStyle(color: Colors.white, fontSize: 30)
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}