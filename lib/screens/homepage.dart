import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/splashscreen_controller.dart';
import 'package:quiz_app/widgets/textview.dart';

// ignore: must_be_immutable
class Homepage extends StatelessWidget {
  Homepage({super.key});

  final splashscreenController = Get.find<SplashscreenController>();

  DateTime? currentBackPressTime;

  Future<bool> confirmExit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      Get.snackbar(
        "Yakin ingin keluar?",
        "Tekan sekali lagi untuk keluar dari aplikasi",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
    return Future.value(false);
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
        onWillPop: confirmExit,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/bg-homepage.svg',
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(FontAwesomeIcons.solidCircleUser,
                              size: 25, color: AppConfig.darkGreen),
                          const SizedBox(width: 10),
                          TextView(headings: "H2", text: splashscreenController.salesIdParams.value),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: splashscreenController.moduleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppConfig.softGreen,
                                          AppConfig.softCyan
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      splashColor:
                                          AppConfig.mainGreen.withOpacity(0.5),
                                      onTap: () {
                                        Get.toNamed(RouteName.quizDashboard);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: TextView(
                                            headings: "H2",
                                            text: splashscreenController
                                                .moduleList[index].moduleID,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      TextView(headings: "H3", text: "v ${splashscreenController.appVersion.value}", fontSize: 14),
                    ],
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
