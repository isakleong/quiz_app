import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/history_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/models/quiz_history.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends GetView<HistoryController> {
  HistoryPage({super.key});

  final SplashscreenController splashscreenController = Get.find();

  final HistoryController historyController = Get.find();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await historyController.getHistoryData(
        splashscreenController.salesIdParams.value,
        historyController.selectedFilter);
    historyController.filterQuizHistoryModel.refresh();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConfig.lightGrayishGreen,
                AppConfig.grayishGreen,
                AppConfig.softGreen,
                AppConfig.softCyan
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Obx(
              () => SmartRefresher(
                physics: const BouncingScrollPhysics(),
                enablePullDown: controller.isLoading.value ? false : true,
                header: MaterialClassicHeader(
                    color: AppConfig.mainGreen, distance: 55),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
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
                          Obx(
                            () => Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible:
                                  controller.isLoading.value ? false : true,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () async {
                                        await historyController.getHistoryData(
                                            splashscreenController
                                                .salesIdParams.value,
                                            historyController.selectedFilter);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConfig.darkGreen,
                                  padding: const EdgeInsets.all(12),
                                  shape: const StadiumBorder(),
                                  elevation: 5,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    FaIcon(FontAwesomeIcons.arrowsRotate),
                                    SizedBox(width: 10),
                                    TextView(
                                        headings: "H3",
                                        text: "Refresh",
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    splashscreenController.salesIdParams.value.contains("C100")
                        ? Center(
                            child: LayoutBuilder(
                              builder: (context, constraints) => Obx(() =>
                                  ToggleButtons(
                                    constraints: BoxConstraints.expand(
                                        width:
                                            (constraints.maxWidth * 0.8) / 3),
                                    fillColor: AppConfig.softGreen,
                                    disabledColor: AppConfig.softGreen,
                                    borderColor: AppConfig.darkGreen,
                                    disabledBorderColor: AppConfig.darkGreen,
                                    borderWidth: 2,
                                    renderBorder: true,
                                    selectedBorderColor: AppConfig.darkGreen,
                                    borderRadius: BorderRadius.circular(30),
                                    isSelected: historyController.selectedFilter
                                        .toList(),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : (int i) async {
                                            await historyController
                                                .applyFilter(i);
                                            historyController
                                                .filterQuizHistoryModel
                                                .refresh();
                                          },
                                    children: const <Widget>[
                                      TextView(headings: "H3", text: "BM"),
                                      TextView(headings: "H3", text: "SPV"),
                                      TextView(headings: "H3", text: "Sales"),
                                    ],
                                  )),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Stack(
                        children: [
                          controller.obx(
                            onLoading: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade400,
                                  highlightColor: Colors.grey.shade200,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: 15,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const SizedBox(height: 160),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            onEmpty: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/lottie/empty.json',
                                      width: Get.width * 0.45),
                                  const SizedBox(height: 30),
                                  const TextView(
                                      headings: "H3", text: Message.emptyData)
                                ],
                              ),
                            ),
                            onError: (error) => Center(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/lottie/error.json',
                                        width: Get.width * 0.5),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: TextView(
                                          headings: "H4",
                                          text:
                                              "Error :\n${controller.errorMessage.value}",
                                          textAlign: TextAlign.start),
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await historyController.getHistoryData(
                                            splashscreenController
                                                .salesIdParams.value,
                                            historyController.selectedFilter);
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
                                              isCapslock: true)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            (state) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Obx(() => historyController
                                      .filterQuizHistoryModel.isNotEmpty
                                  ? ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: historyController
                                          .filterQuizHistoryModel.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return historyWidget(
                                            historyController
                                                .filterQuizHistoryModel,
                                            i);
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget historyWidget(List<QuizHistory> quizHistoryList, int i) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
              colors: quizHistoryList[i].passed == "1"
                  ? [AppConfig.mainCyan, AppConfig.softCyan]
                  : [AppConfig.mainRed, AppConfig.softRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Stack(children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                    size: Size(Get.width * 0.20, Get.height),
                    painter: quizHistoryList[i].passed == "1"
                        ? CustomCardShapePainter(
                            30.0, AppConfig.mainCyan, AppConfig.softCyan)
                        : CustomCardShapePainter(
                            30.0, AppConfig.mainRed, AppConfig.softRed)),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    quizHistoryList[i].passed == "1"
                        ? Icons.check
                        : Icons.close,
                    color: quizHistoryList[i].passed == "1"
                        ? AppConfig.mainGreen
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextView(
                          headings: "H3",
                          text: quizHistoryList[i].salesID,
                          color: Colors.white,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 20),
                      TextView(
                          headings: "H3",
                          text: quizHistoryList[i].name,
                          color: Colors.white,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 20),
                      TextView(
                          headings: "H3",
                          text: quizHistoryList[i].tanggal,
                          color: Colors.white,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                    ],
                  ),
                ),
                const Expanded(
                  child: TextView(
                    headings: "H2",
                    // text: historyController.quizHistoryModel[i].passed == "1" ? "lulus" : "tidak lulus",
                    text: '',
                    fontSize: 16,
                    color: Colors.white,
                    isCapslock: true,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
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
    paint.shader = ui.Gradient.linear(
        const Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.9).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
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
