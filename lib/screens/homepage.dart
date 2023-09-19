import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/widgets/textview.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final splashscreenController = Get.find<SplashscreenController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return Future.value(false);
        },
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.darkGreen,
                          elevation: 5,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Icon(FontAwesomeIcons.xmark,
                            size: 35, color: Colors.white),
                      ),
                      Expanded(
                        child: Obx(() {
                            return Center(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: splashscreenController.moduleList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return 
                                  splashscreenController.moduleList[index].moduleID.toLowerCase() == "taking order vendor" ?
                                  SizedBox() :  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppConfig.softGreen,
                                              AppConfig.softCyan,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(16),
                                            splashColor: AppConfig.mainGreen
                                                .withOpacity(0.5),
                                            onTap: () async {
                                              splashscreenController.buttonAction(
                                                  splashscreenController
                                                      .moduleList[index].moduleID);
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
                                    ),
                                  ) ;
                                },
                              ),
                            );
                        },) 
                      ),
                      TextView(
                          headings: "H3",
                          text: "v ${splashscreenController.appVersion.value}",
                          fontSize: 14),
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
