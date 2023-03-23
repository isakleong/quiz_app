import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/widgets/textview.dart';

class SplashScreen extends StatelessWidget {
 SplashScreen({super.key});

  final configController = Get.find<ConfigController>();

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        width: mediaWidth,
        height: mediaHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/logo.png", 
                alignment: Alignment.center, 
                fit: BoxFit.contain,
                // width: mediaWidth*0.6,
                width: 250,
              ),
              Lottie.asset(
                'assets/lottie/welcome.json',
                width: mediaWidth*0.5,
              ),
              Obx(() {
                if (configController.isLoading.value) {
                  return Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 60,
                  );
                } else if (configController.isError.value) {
                  return ElevatedButton(
                    onPressed: () {
                      configController.getModuleData();
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
                        TextView(headings: "H3", text: "Coba Lagi", fontSize: 16, color: Colors.white)
                      ],
                    ),
                  );
                } else {
                  return const Text("");
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}