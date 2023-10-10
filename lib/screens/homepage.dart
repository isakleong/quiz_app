import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/textview.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final splashscreenController = Get.find<SplashscreenController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          key: splashscreenController.keyhome,
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
                      Expanded(child: Obx(
                        () {
                          return Center(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  splashscreenController.moduleList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return splashscreenController
                                            .moduleList[index].moduleID
                                            .toLowerCase() ==
                                        "taking order vendor"
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                splashColor: AppConfig.mainGreen
                                                    .withOpacity(0.5),
                                                onTap: () async {
                                                  splashscreenController
                                                      .buttonAction(
                                                          splashscreenController
                                                              .moduleList[index]
                                                              .moduleID);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: TextView(
                                                      headings: "H2",
                                                      text:
                                                          splashscreenController
                                                              .moduleList[index]
                                                              .moduleID,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                          );
                        },
                      )),
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
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 0.1 * height, left: 0.08 * width),
            child: SizedBox(
              height: 0.125 * width,
              width: 0.125 * width,
              child: FloatingActionButton(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                onPressed: () {
                  Get.defaultDialog(
                    radius: 6,
                    barrierDismissible: true,
                    title: "",
                    titlePadding: const EdgeInsets.only(top: 0, bottom: 0),
                    confirm: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: OutlinedButton(
                        onPressed: () async {
                            Get.back();
                            splashscreenController.showloadingbanner(context);
                            splashscreenController.unduhmoduleaccess();
                            // print(await Utils().getParameterData("sales"));
                            // splashscreenController.unduhdataitem();
                            // splashscreenController.unduhdataroute();
                          },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        child: const Text("YA",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    cancel: OutlinedButton(
                      onPressed: () => {Get.back()},
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.teal),
                          backgroundColor: Colors.white),
                      child: const Text("BATAL",
                          style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal)),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                    content: Column(
                      children: [
                        const Text("Informasi",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(height: 25),
                        Lottie.asset('assets/lottie/confirmquestion.json',
                            width: width * 0.25),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text("Apakah anda ingin unduh ulang data ?",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 15,
                                color: Colors.grey.shade800)),
                        const SizedBox(height: 6),
                      ],
                    ),
                  );
                },
                child: Icon(
                  Icons.download,
                  size: 0.065 * width,
                ), // You can replace this with any icon
              ),
            ),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
        ),
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(-16.0, scaffoldGeometry.scaffoldSize.height - 100.0);
  }
}
