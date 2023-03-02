import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class StartQuiz extends GetView<QuizController>  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.lightGreenColor,
      body: controller.obx(
        (state)=> CircularButton(),
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: Center(child: Lottie.asset('assets/lottie/loading.json', width: 60)),
        onEmpty: const Text('No data found'),
        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error)=>const Text("error"),
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