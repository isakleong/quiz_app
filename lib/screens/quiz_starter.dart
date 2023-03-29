import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/widgets/textview.dart';

class StartQuiz extends GetView<QuizController>  {
  StartQuiz({super.key});

  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children:[
          SvgPicture.asset(
            'assets/images/bg-starter.svg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 40, bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.darkGreen,
                elevation: 0,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(FontAwesomeIcons.arrowLeft, size: 25, color: Colors.white),
            ),
          ),
          controller.obx(
            (state) => const CircularButton(),
            onLoading: Center(
              child: Lottie.asset('assets/lottie/loading.json', width: 60),
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
                      child: TextView(headings: "H3", text: "Error :\n${controller.errorMessage.value}", fontSize: 16, textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        quizController.getQuizConfig();
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
                          TextView(headings: "H3", text: "Coba Lagi", fontSize: 16, color: Colors.white),
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
  const CircularButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: ClipOval(
            child: Container(
              color: AppConfig.mainGreen,
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
              color: AppConfig.mainGreen,
              shape: const CircleBorder(),
              child: InkWell(
                splashColor: AppConfig.lightSoftGreen,
                customBorder: const CircleBorder(),
                onTap: () {
                  Get.offAndToNamed(RouteName.countdown);
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: TextView(headings: "H1", text: "mulai", fontSize: 40, color: Colors.white, isCapslock: true),
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