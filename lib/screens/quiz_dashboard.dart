import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/screens/quiz_starter.dart';
import 'package:quiz_app/widgets/textview.dart';

class QuizDashboard extends StatelessWidget {
  const QuizDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppConfig.lightGrayishGreen, AppConfig.grayishGreen, AppConfig.softGreen, AppConfig.softCyan]
        ),
      ),
      child: Scaffold(
        // backgroundColor: AppConfig.lightSoftGreen.withOpacity(1),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height*0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(Get.width * 0.5, 80),
                      bottomRight: Radius.elliptical(Get.width * 0.5, 80),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                        color: const Color(0xff808080).withOpacity(0.5))
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(Get.width * 0.5, 80),
                      bottomRight: Radius.elliptical(Get.width * 0.5, 80),
                    ),
                    // child: SvgPicture.asset('assets/images/bg-dashboard.svg', semanticsLabel: 'secret', fit: BoxFit.cover),
                    child: Image.asset('assets/images/bg_rev.png', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(result: Get.arguments);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Icon(FontAwesomeIcons.arrowLeft, size: 25, color:AppConfig.darkGreen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 5,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      highlightColor: AppConfig.mainGreen.withOpacity(0.15),
                      splashColor: AppConfig.mainGreen.withOpacity(0.15),
                      onTap: () async {
                        Get.toNamed(RouteName.starter);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                            ).createShader(bounds),
                            child: const FaIcon(FontAwesomeIcons.filePen, color: Colors.white, size: 50),
                          ),
                          const SizedBox(height: 30),
                          const TextView(headings: "H2", text: "Kuis", fontSize: 24),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 5,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      highlightColor: AppConfig.mainGreen.withOpacity(0.15),
                      splashColor: AppConfig.mainGreen.withOpacity(0.15),
                      onTap: (){
                        Get.toNamed(RouteName.history);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                            ).createShader(bounds),
                            child: const FaIcon(FontAwesomeIcons.solidRectangleList, size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 30),
                          const TextView(headings: "H2", text: "Riwayat", fontSize: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}