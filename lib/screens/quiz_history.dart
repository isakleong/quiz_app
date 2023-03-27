import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/history_controller.dart';

class HistoryPage extends GetView<HistoryController>  {
  HistoryPage({super.key});

  final HistoryController historyController = Get.find();

  openDialog(String errorMessage) {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/error.json',
                width: 100,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Obx(() => Text(
                  "Error message :\n$errorMessage"
                  )
                )
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFF4FCF5), AppConfig.lightOpactityGreenColor, AppConfig.lightGreenColor, AppConfig.mainGreenColor]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 40, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.darkGreenColor,
                  elevation: 0,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(FontAwesomeIcons.arrowLeft, size: 25, color: Colors.white),
              ),
            ),
            Expanded(
              // height: mediaHeight,
              child: Stack(
                children: [
                  controller.obx(
                    onLoading: Center(child: Lottie.asset('assets/lottie/loading.json', width: 60)),
                    onEmpty: const Text('No data found'),
                    onError: (error) => Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/error.json',
                              width: mediaWidth*0.5,
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text("Error :\n${controller.errorMessage.value}", style: TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                // final HistoryController historyController = Get.find();
                                // quizController.fetchQuizData();
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
                                  Text("Coba Lagi", style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (state) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Obx(() => ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: historyController.quizHistoryModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Stack(
                              children: [
                                Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(30),
                                  shadowColor: Colors.grey,
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: LinearGradient(
                                        colors: historyController.quizHistoryModel[index].passed == "1" ? 
                                        [const Color(0xFF11998E), const Color(0xFF38EF7D)]
                                        : 
                                        [const Color(0xFFEB3349), const Color(0xFFF45C43)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight
                                      ),
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     color: Colors.grey,
                                      //     blurRadius: 7,
                                      //     offset: Offset(0, 1)
                                      //   )
                                      // ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children:[
                                      CustomPaint(
                                        size: const Size(100, 150),
                                        painter: historyController.quizHistoryModel[index].passed == "1" ? 
                                        CustomCardShapePainter(30.0, const Color(0xFF11998E), const Color(0xFF38EF7D))
                                        :
                                        CustomCardShapePainter(30.0, const Color(0xFFEB3349), const Color(0xFFF45C43))
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          historyController.quizHistoryModel[index].passed == "1" ? 
                                          Icons.check
                                          :
                                          Icons.close,
                                          color: historyController.quizHistoryModel[index].passed == "1" ? 
                                          AppConfig.mainGreenColor
                                          :
                                          Colors.red,
                                        )
                                      )
                                    ] 
                                  ),
                                ),
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(historyController.quizHistoryModel[index].salesID, style: const TextStyle(fontSize: 16, color: Colors.white)),
                                              const SizedBox(height: 20),
                                              AutoSizeText(historyController.quizHistoryModel[index].name, maxLines: 1, style: const TextStyle(fontSize: 16, color: Colors.white)),
                                              const SizedBox(height: 20),
                                              Text(historyController.quizHistoryModel[index].tanggal, style: const TextStyle(fontSize: 16, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            historyController.quizHistoryModel[index].passed == "1" ? 
                                            "LULUS"
                                            :
                                            "TIDAK LULUS", 
                                            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          );
                        }),
                      ), 
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 30.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(const Offset(0,0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.9).toColor(), endColor
    ]);

    var path = Path()..moveTo(0, size.height)..lineTo(size.width - radius, size.height)..quadraticBezierTo(size.width, size.height, size.width, size.height-radius)..lineTo(size.width, radius)..quadraticBezierTo(size.width, 0, size.width - radius, 0)..lineTo(size.width - 1.5 * radius, 0)..quadraticBezierTo(-radius, 2 * radius, 0, size.height)..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


class CircularButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: ClipOval(
            child: Container(
              color: AppConfig.mainGreenColor,
              height: 250,
              width: 250,
            ),
          ),
        ),

        Center(
          child: Container(
            height: 230,
            width: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 10,
                style: BorderStyle.solid
              ),
            ),
            child: Material(
              color: AppConfig.mainGreenColor,
              shape: const CircleBorder(),
              child: InkWell(
                splashColor: AppConfig.lightGreenColor,
                customBorder: const CircleBorder(),
                onTap: () {
                  Get.offAndToNamed(RouteName.countdown);
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'MULAI',
                      style: TextStyle(color: Colors.white, fontSize: 30)
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}