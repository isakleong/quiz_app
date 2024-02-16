import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/common/message_config.dart';
import 'package:sfa_tools/controllers/coupon_mab_controller.dart';
import 'package:sfa_tools/controllers/splashscreen_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/dialogconfirm.dart';
import 'package:sfa_tools/tools/utils.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
                child: Obx(() => controller.listDataMAB.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.listDataMAB.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                            child: Material(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              elevation: 1.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                                  child: Stack(
                                    children: [
                                      Positioned( //positioned helps to position widget wherever we want.
                                        top: -15,
                                        left: -45,
                                        child:Container( 
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            shape:BoxShape.circle,
                                            color:Colors.orange.withOpacity(0.5)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 25),
                                            child: Center(
                                              child: TextView(headings: "H3", text: (index + 1).toString(), fontSize: 16, color: Colors.black, isAutoSize: true,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 60, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 12),
                                            TextView(headings: "H3", text: controller.listDataMAB[index].id, fontSize: 16, color: Colors.black, isAutoSize: true, textAlign: TextAlign.start, maxLines: 1),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextView(headings: "H3", text:controller.listDataMAB[index].jenis ?? "Jenis", fontSize: 14, color: Colors.black),
                                                TextView(headings: "H3", text: DateFormat("dd-MM-yyyy (HH:mm)").format(DateTime.parse(controller.listDataMAB[index].createdOn!)), fontSize: 14, color: Colors.black),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Divider(color: Colors.grey.shade300, thickness: 3, height: 3, indent: 0, endIndent: 10),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const FaIcon(FontAwesomeIcons.userPen, color: Colors.deepOrangeAccent, size: 16),
                                                          const SizedBox(width: 12),
                                                          TextView(headings: "H3", text: "${controller.listDataMAB[index].createdBy} (${controller.listDataMAB[index].createdBy})", fontSize: 14, color: Colors.grey.shade600),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          const FaIcon(FontAwesomeIcons.store, color: Colors.deepOrangeAccent, size: 16),
                                                          const SizedBox(width: 13),
                                                          TextView(headings: "H3", text: "${controller.listDataMAB[index].custID} (${controller.listDataMAB[index].custName})", fontSize: 14, color: Colors.grey.shade600),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const FaIcon(FontAwesomeIcons.mapLocationDot, color: Colors.deepOrangeAccent, size: 16),
                                                          const SizedBox(width: 13),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                TextView(headings: "H3", text: "${controller.listDataMAB[index].alamat}", fontSize: 14, color: Colors.grey.shade600),
                                                                const SizedBox(height: 3),
                                                                TextView(headings: "H3", text: "Provinsi ${controller.listDataMAB[index].provinsi}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                const SizedBox(height: 3),
                                                                TextView(headings: "H3", text: "Kota ${controller.listDataMAB[index].kota}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                const SizedBox(height: 3),
                                                                TextView(headings: "H3", text: "Kelurahan ${controller.listDataMAB[index].kelurahan}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                const SizedBox(height: 3),
                                                                TextView(headings: "H3", text: "Kecamatan ${controller.listDataMAB[index].kecamatan}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                const SizedBox(height: 3),
                                                                TextView(headings: "H3", text: "Kode Pos ${controller.listDataMAB[index].kodePos}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Divider(color: Colors.grey.shade300, thickness: 3, height: 3, indent: 0, endIndent: 10),
                                            const SizedBox(height: 8),
                                            Column(
                                              children: [
                                                Center(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700),
                                                    onPressed: () async {                                                                  
                                                      Get.defaultDialog(
                                                        radius: 6,
                                                        barrierDismissible: false,
                                                        title: "",
                                                        titlePadding: const EdgeInsets.only(top: 0, bottom: 0),
                                                        contentPadding: const EdgeInsets.only(bottom: 0),
                                                        content: Container(
                                                          width: Get.width,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  Positioned(
                                                                    right: 10,
                                                                    child: ElevatedButton(
                                                                      onPressed: () {
                                                                        Get.back();
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: AppConfig.darkGreen,
                                                                        elevation: 5,
                                                                        shape: const CircleBorder(),
                                                                        padding: const EdgeInsets.all(10),
                                                                      ),
                                                                      child: const Icon(FontAwesomeIcons.xmark,
                                                                          size: 30, color: Colors.white),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      controller.listDataMAB[index].jenis==null ||controller.listDataMAB[index].jenis!.toLowerCase().contains("mab") 
                                                                      ?
                                                                      Column(
                                                                        children: [
                                                                          const Center(
                                                                            child: TextView(headings: "H3", text: "Insentif Scan Kupon MAB", fontSize: 16, color: Colors.black)
                                                                          ),
                                                                          const SizedBox(height: 5),
                                                                          Center(child: TextView(headings: "H3", text: "${controller.listDataMAB[index].custID} (${controller.listDataMAB[index].custName})", fontSize: 16, color: Colors.black)),
                                                                        ],
                                                                      )
                                                                      :
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          const Center(child: TextView(headings: "H3", text: "Insentif Karyawan Toko", fontSize: 16, color: Colors.black)),
                                                                          const SizedBox(height: 5),
                                                                          Center(child: TextView(headings: "H3", text: "${controller.listDataMAB[index].custID} (${controller.listDataMAB[index].custName})", fontSize: 16, color: Colors.black)),
                                                                        ],
                                                                      ),
                                                                      // Utils.decodeImage(controller.listDataMAB[index].stampPhoto.toString())
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10),
                                                              Divider(color: Colors.grey.shade300, thickness: 3, height: 3, indent: 10, endIndent: 10),
                                                              const SizedBox(height: 10),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            const FaIcon(FontAwesomeIcons.userPen, color: Colors.deepOrangeAccent, size: 16),
                                                                            const SizedBox(width: 12),
                                                                            TextView(headings: "H3", text: "${controller.listDataMAB[index].createdBy} (${controller.listDataMAB[index].createdBy})", fontSize: 14, color: Colors.grey.shade600),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(height: 10),
                                                                        Row(
                                                                          children: [
                                                                            const FaIcon(FontAwesomeIcons.store, color: Colors.deepOrangeAccent, size: 16),
                                                                            const SizedBox(width: 13),
                                                                            TextView(headings: "H3", text: "${controller.listDataMAB[index].custID} (${controller.listDataMAB[index].custName})", fontSize: 14, color: Colors.grey.shade600),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(height: 10),
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            const FaIcon(FontAwesomeIcons.mapLocationDot, color: Colors.deepOrangeAccent, size: 16),
                                                                            const SizedBox(width: 13),
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  TextView(headings: "H3", text: "${controller.listDataMAB[index].alamat}", fontSize: 14, color: Colors.grey.shade600),
                                                                                  const SizedBox(height: 3),
                                                                                  TextView(headings: "H3", text: "Provinsi ${controller.listDataMAB[index].provinsi}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                  const SizedBox(height: 3),
                                                                                  TextView(headings: "H3", text: "Kota ${controller.listDataMAB[index].kota}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                  const SizedBox(height: 3),
                                                                                  TextView(headings: "H3", text: "Kelurahan ${controller.listDataMAB[index].kelurahan}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                  const SizedBox(height: 3),
                                                                                  TextView(headings: "H3", text: "Kecamatan ${controller.listDataMAB[index].kecamatan}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                  const SizedBox(height: 3),
                                                                                  TextView(headings: "H3", text: "Kode Pos ${controller.listDataMAB[index].kodePos}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 12),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      );

                                                      Get.dialog(
                                                        Dialog(
                                                        backgroundColor: Colors.white,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(10))),
                                                        child: DialogConfirm(
                                                          message: "msg",
                                                          title: "title",
                                                          onTap: (){},
                                                        ))
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      width: 140,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: const [                                                          
                                                          TextView(headings: "H2", text: "Detail", fontSize: 14, color: Colors.white, isCapslock: true),
                                                          SizedBox(width: 8),
                                                          FaIcon(FontAwesomeIcons.eye, color: Colors.white, size: 20),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                          // Container(
                          //   child: Text(controller
                          //   .listDataMAB[i].id.toString()),
                          // );
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