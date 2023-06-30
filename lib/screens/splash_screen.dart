import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/message_config.dart';
import 'package:quiz_app/controllers/splashscreen_controller.dart';
import 'package:quiz_app/models/config_box.dart';
import 'package:quiz_app/widgets/dialog.dart';
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
                          Image.asset(
                            "assets/images/logo.png", 
                            alignment: Alignment.center, 
                            fit: BoxFit.contain,
                            width: Get.width*0.4,
                            // width: 250,
                          ),
                          Lottie.asset(
                            'assets/lottie/welcome.json',
                            width: Get.width*0.5,
                          ),
                          controller.obx(
                            onLoading: Lottie.asset('assets/lottie/loading.json', width: 60),
                            onError: (error) => Column(
                              children: [
                                ElevatedButton(
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
                                const SizedBox(height: 30),
                                InkWell(
                                  onTap: () {
                                    appsDialog(
                                      type: "confirm_dialog",
                                      title: const TextView(headings: "H2", text: "Pengaturan", fontSize: 16, isCapslock: true),
                                      content: Column(
                                        children: [
                                          TextField(
                                            controller: controller.txtServerIPController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'IP Server',
                                              hintText: 'Input IP Server',
                                            ),
                                          ),
                                        ],
                                      ),
                                      isAnimated: false,
                                      isCancel: false,
                                      leftBtnMsg: "Simpan",
                                      leftActionClick: () async {
                                        Get.back();
                                        var mybox = await Hive.openBox<ConfigBox>("configBox");
                                        await mybox.put("configBox", ConfigBox(value: controller.txtServerIPController.text.toString()));
                                      },
                                    );
                                  },
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                                    ).createShader(bounds),
                                    child: const FaIcon(FontAwesomeIcons.gear, color: Colors.white, size: 50),
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