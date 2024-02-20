import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/coupon_mab_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/screens/coupon_mab/approval_item.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 10,),
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Obx(() =>
                      ToggleButtons(
                        constraints: BoxConstraints.expand(
                          width: (constraints.maxWidth * 0.8) / 2),
                          fillColor: AppConfig.softGreen,
                            disabledColor: AppConfig.softGreen,
                            borderColor: AppConfig.darkGreen,
                            disabledBorderColor: AppConfig.darkGreen,
                            borderWidth: 2,
                            renderBorder: true,
                            selectedBorderColor: AppConfig.darkGreen,
                            borderRadius: BorderRadius.circular(30),
                            isSelected: controller.selectedFilter.toList(),
                            onPressed: controller.isLoading.value
                            ? null
                            : (int i) async {
                              await controller.applyFilter(i);
                              controller.searchListDataMAB.refresh();

                              controller.searchController.clear();
                              // ignore: use_build_context_synchronously
                              FocusScope.of(context).unfocus();
                            },
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const TextView(headings: "H3", text: "Kupon MAB"),
                                  const SizedBox(width: 10,),
                                  controller.isLoading.value 
                                  ? 
                                  Container() 
                                  :
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepOrange.shade600,
                                    ),
                                    child: Obx(() => TextView(headings: "H3", text: "${controller.cntMAB}", color:Colors.white)),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const TextView(headings: "H3", text: "Karyawan Toko"),
                                  const SizedBox(width: 10,),
                                  controller.isLoading.value 
                                  ? 
                                  Container() 
                                  :
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepOrange.shade600,
                                    ),
                                    child: Obx(() => TextView(headings: "H3", text: "${controller.cntKaryawanToko}", color: Colors.white,)),
                                  ),
                                ],
                              ),
                            ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: (value) => controller.searchData(value),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Cari Data',
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: AppConfig.mainGreen),
                          ),
                          prefixIcon: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Color(0XFF319088),
                            size: 16,
                          )),
                    ),
                  ),
                  Expanded(
                    child: controller.obx(
                    (state) =>  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Obx(() => controller.searchListDataMAB.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.searchListDataMAB.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ApprovalItem(index: index, listDataMAB: controller.searchListDataMAB);
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
                              'assets/lottie/empty.json',
                              width: Get.width * 0.5,
                            ),
                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: TextView(
                                  headings: "H3",
                                  text: Message.emptyData,
                                  textAlign: TextAlign.center),
                            ),
                            // const SizedBox(height: 30),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Get.back();
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: AppConfig.darkGreen,
                            //     padding: const EdgeInsets.all(12),
                            //   ),
                            //   child: const TextView(
                            //       headings: "H3",
                            //       text: "ok",
                            //       color: Colors.white,
                            //       isCapslock: true),
                            // ),
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