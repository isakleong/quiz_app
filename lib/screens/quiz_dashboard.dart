import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
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
                    child: Image.asset('assets/images/bg_rev.png', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
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
                          const TextView(headings: "H2", text: "Kuis", fontSize: 20),
                          // const Text("Kuis")
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
                          const TextView(headings: "H2", text: "Riwayat", fontSize: 20, isAutoSize: true),
                          // const AutoSizeText(
                          //   'Riwayat',
                          //   minFontSize: 16,
                          //   maxFontSize: 28,
                          //   overflow: TextOverflow.ellipsis,
                          // )

                          // const FittedBox(
                          //   fit: BoxFit.scaleDown,
                          //   child: Text(
                          //     'This is some text',
                          //     style: TextStyle(fontSize: 20),
                          //   ),
                          // )
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