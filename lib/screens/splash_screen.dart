import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/message_config.dart';
import 'package:quiz_app/controllers/splashscreen_controller.dart';
import 'package:quiz_app/widgets/textview.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashscreenController>(
        init: SplashscreenController(),
        builder: (controller) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
              body: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/logo.png", 
                        alignment: Alignment.center, 
                        fit: BoxFit.contain,
                        // width: Get.width*0.6,
                        width: 250,
                      ),
                      Lottie.asset(
                        'assets/lottie/welcome.json',
                        width: Get.width*0.5,
                      ),
                      controller.obx(
                        onLoading: Lottie.asset('assets/lottie/loading.json', width: 60),
                        onError: (error) => ElevatedButton(
                          onPressed: () {
                            controller.checkUpdate();
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
                              TextView(headings: "H3", text: Message.retry, fontSize: 16, color: Colors.white, isCapslock: true),
                            ],
                          ),
                        ),
                        (state) => Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}