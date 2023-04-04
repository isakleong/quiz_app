import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/controllers/history_controller.dart';
import 'package:quiz_app/widgets/textview.dart';

class HistoryPage extends GetView<HistoryController>  {
  HistoryPage({super.key});

  final HistoryController historyController = Get.find();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 500));
    await historyController.getHistoryData();
    historyController.filterQuizHistoryModel.refresh();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // colors: [AppConfig.lightGrayishGreen, AppConfig.grayishGreen, AppConfig.lightSoftGreen, AppConfig.softGreen]
            colors: [AppConfig.lightGrayishGreen, AppConfig.grayishGreen, AppConfig.softGreen, AppConfig.softCyan]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SmartRefresher(
          physics: const BouncingScrollPhysics(),
          enablePullDown: true,
          header: MaterialClassicHeader(color: AppConfig.mainGreen, distance: 55),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.darkGreen,
                        elevation: 0,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(FontAwesomeIcons.arrowLeft, size: 25, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await historyController.getHistoryData();
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
                          TextView(headings: "H3", text: "Refresh", fontSize: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Center(
              //   child: GetBuilder<HistoryController>( // no need to initialize Controller ever again, just mention the type
              //     builder: (value) => LayoutBuilder(
              //       builder: (context, constraints) => Obx(() => ToggleButtons(
              //         constraints: BoxConstraints.expand(width: (constraints.maxWidth*0.8)/3),
              //         fillColor: AppConfig.softGreen,
              //         borderColor: AppConfig.darkGreen,
              //         borderWidth: 1.5,
              //         renderBorder: true,
              //         selectedBorderColor: AppConfig.darkGreen,
              //         borderRadius: BorderRadius.circular(30),
              //         // focusNodes: focusToggle,
              //         isSelected: value.selectedLimitRequestHistoryData,
              //         onPressed: (int i) async {
              //           await value.applyFilter(i);
              //           value.filterQuizHistoryModel.refresh();
              //         },
              //         children: const <Widget>[
              //           TextView(headings: "H3", text: "Branch Manager", fontSize: 16),
              //           TextView(headings: "H3", text: "Supervisor", fontSize: 16),
              //           TextView(headings: "H3", text: "Sales", fontSize: 16),
              //         ],
              //       )),
              //     ),
              //   ),
              // ),

              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) => Obx(() => ToggleButtons(
                    constraints: BoxConstraints.expand(width: (constraints.maxWidth*0.8)/3),
                    fillColor: AppConfig.softGreen,
                    borderColor: AppConfig.darkGreen,
                    borderWidth: 1.5,
                    renderBorder: true,
                    selectedBorderColor: AppConfig.darkGreen,
                    borderRadius: BorderRadius.circular(30),
                    // focusNodes: focusToggle,
                    isSelected: historyController.selectedLimitRequestHistoryData.toList(),
                    onPressed: (int i) async {
                      await historyController.applyFilter(i);
                      historyController.filterQuizHistoryModel.refresh();
                    },
                    children: const <Widget>[
                      TextView(headings: "H3", text: "Branch Manager", fontSize: 16),
                      TextView(headings: "H3", text: "Supervisor", fontSize: 16),
                      TextView(headings: "H3", text: "Sales", fontSize: 16),
                    ],
                  )),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    controller.obx(
                      onLoading: Center(
                        child: Lottie.asset('assets/lottie/loading.json', width: 60),
                      ),
                      onEmpty: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/lottie/empty.json', width: Get.width*0.45),
                            const SizedBox(height: 30),
                            const TextView(headings: "H3", text: "Tidak ada data", fontSize: 18),
                          ],
                        ),
                      ),
                      onError: (error) => Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/lottie/error.json', width: Get.width*0.5),
                              const SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: TextView(headings: "H4", text: "Error :\n${controller.errorMessage.value}", textAlign: TextAlign.start, fontSize: 16),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () async {
                                  await historyController.getHistoryData();
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
                                    TextView(headings: "H3", text: "Coba Lagi", fontSize: 16, color: Colors.white)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      (state) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                        child: Obx(() => 
                        historyController.filterQuizHistoryModel.isNotEmpty ?
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: historyController.filterQuizHistoryModel.length,
                          itemBuilder: (BuildContext context, int i) {
                            return historyWidget(historyController, i);
                          }
                        )
                        :
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/lottie/empty.json', width: Get.width*0.45),
                              const SizedBox(height: 30),
                              const TextView(headings: "H3", text: "Tidak ada data", fontSize: 18),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget historyWidget(HistoryController historyController, int i) {
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
                colors: historyController.quizHistoryModel[i].passed == "1" ? 
                [AppConfig.mainCyan, AppConfig.softCyan]
                :
                [AppConfig.mainRed, AppConfig.softRed],
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
                painter: historyController.quizHistoryModel[i].passed == "1" ? 
                CustomCardShapePainter(30.0, AppConfig.mainCyan, AppConfig.softCyan)
                :
                CustomCardShapePainter(30.0, AppConfig.mainRed, AppConfig.softRed)
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  historyController.quizHistoryModel[i].passed == "1" ? 
                  Icons.check
                  :
                  Icons.close,
                  color: historyController.quizHistoryModel[i].passed == "1" ? 
                  AppConfig.mainGreen
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
                      TextView(headings: "H3", text: historyController.quizHistoryModel[i].salesID, fontSize: 16, color: Colors.white),
                      const SizedBox(height: 20),
                      TextView(headings: "H3", text: historyController.quizHistoryModel[i].name, fontSize: 16, color: Colors.white, isAutoSize: true),
                      const SizedBox(height: 20),
                      TextView(headings: "H3", text: historyController.quizHistoryModel[i].tanggal, fontSize: 16, color: Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: TextView(
                    headings: "H2",
                    text: historyController.quizHistoryModel[i].passed == "1" ? "lulus" : "tidak lulus",
                    fontSize: 16,
                    color: Colors.white,
                    isCapslock: true,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
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

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height-radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}