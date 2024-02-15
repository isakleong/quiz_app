import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/coupon_mab_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/widgets/textview.dart';

class CouponMAB extends GetView<CouponMABController> {
  CouponMAB({super.key});

  final quizController = Get.find<CouponMABController>();
  final salesIdParams = Get.find<SplashscreenController>().salesIdParams;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/bg-homepage.svg',
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
                  elevation: 5,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(FontAwesomeIcons.arrowLeft,
                    size: 25, color: Colors.white),
              ),
            ),
            controller.obx(
              (state) =>  Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10),
                child: Obx(() => controller
                        .listDataMAB.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller
                            .listDataMAB.length,
                        itemBuilder:
                            (BuildContext context, int i) {
                          return Container(
                            child: Text(controller
                            .listDataMAB[i].id.toString()),
                          );
                        })
                    : Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                'assets/lottie/empty.json',
                                width: Get.width * 0.45),
                            const SizedBox(height: 30),
                            const TextView(
                                headings: "H3",
                                text: Message.emptyData),
                          ],
                        ),
                      )),
              ),
              onLoading: Center(
                child: Lottie.asset('assets/lottie/loading.json', width: 60),
              ),
              onEmpty: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/quiz-retry.json',
                        width: Get.width * 0.5,
                      ),
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextView(
                            headings: "H3",
                            text: Message.warningQuizNotSent,
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.darkGreen,
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const TextView(
                            headings: "H3",
                            text: "ok",
                            color: Colors.white,
                            isCapslock: true),
                      ),
                    ],
                  ),
                ),
              ),
              onError: (error) => Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/error.json',
                        width: Get.width * 0.5,
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextView(
                            headings: "H3",
                            text: controller.errorMessage.value,
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // quizController.getQuizConfig(salesIdParams.value);
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
                                color: Colors.white,
                                isCapslock: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}