import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/widgets/textview.dart';

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
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: Get.height,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Visibility(
                                visible: controller.isError.value ? true : false,
                                child: ElevatedButton(
                                  onPressed: () {
                                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConfig.darkGreen,
                                    elevation: 5,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  child: const Icon(FontAwesomeIcons.xmark, size: 35, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/images/logo.png",
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            width: Get.width * 0.4,
                            // width: 250,
                          ),
                          Lottie.asset(
                            'assets/lottie/welcome.json',
                            width: Get.width * 0.5,
                          ),
                          controller.obx(
                            onLoading: Lottie.asset(
                                'assets/lottie/loading.json',
                                width: 60),
                            onError: (error) => Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    controller.retrypermission ? controller.startApp() : controller.getmoduledataall();
                                    // controller.getModuleData();
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
                                      TextView(
                                          headings: "H3",
                                          text: Message.retry,
                                          fontSize: 16,
                                          color: Colors.white,
                                          isCapslock: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            (state) => Container(),
                          ),
                        ],
                      ),
                    ),
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
