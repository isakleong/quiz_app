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
                          width: (constraints.maxWidth * 0.8) / 3),
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
                              controller.filterlistDataMAB.refresh();
                            },
                            children: const <Widget>[
                              TextView(headings: "H3", text: "Kupon MAB"),
                              TextView(headings: "H3", text: "Karyawan Toko"),
                              TextView(headings: "H3", text: "Dummy"),
                            ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: controller.obx(
                    (state) =>  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                                                      TextView(headings: "H3", text: controller.listDataMAB[index].jenis, fontSize: 14, color: Colors.black),
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
                                                                const SizedBox(width: 8),
                                                                SizedBox(width: 50, child: TextView(headings: "H3", text: "Sales", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start)),
                                                                Expanded(child: TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].createdBy} (${controller.listDataMAB[index].salesName})", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),)
                                                              ],
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Row(
                                                              children: [
                                                                const FaIcon(FontAwesomeIcons.store, color: Colors.deepOrangeAccent, size: 16),
                                                                const SizedBox(width: 8),
                                                                SizedBox(width: 50, child: TextView(headings: "H3", text: "Toko", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start)),
                                                                Expanded(child: TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].custID} (${controller.listDataMAB[index].custName})", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),)
                                                              ],
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Row(
                                                              children: [
                                                                const FaIcon(FontAwesomeIcons.idCardClip, color: Colors.deepOrangeAccent, size: 16),
                                                                const SizedBox(width: 8),
                                                                SizedBox(width: 50, child: TextView(headings: "H3", text: "Nama", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start)),
                                                                Expanded(
                                                                  child: controller.listDataMAB[index].namaBelakang!="-" ?
                                                                  TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].namaDepan} ${controller.listDataMAB[index].namaBelakang}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start)
                                                                  :
                                                                  TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].namaDepan}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start)
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Row(
                                                              children: [
                                                                const FaIcon(FontAwesomeIcons.phone, color: Colors.deepOrangeAccent, size: 16),
                                                                const SizedBox(width: 8),
                                                                SizedBox(width: 50, child: TextView(headings: "H3", text: "No HP", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start)),
                                                                Expanded(child: TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].noHp}", fontSize: 14, color: Colors.grey.shade600, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),)
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
                                                              content: SizedBox(
                                                                width: Get.width,
                                                                height: Get.height*0.8,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: const [
                                                                              TextView(headings: "H3", text: "Nama", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Jenis Kelamin", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Tempat Lahir", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Tanggal Lahir", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Nomor HP", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Alamat", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Provinsi", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Kota", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Kecamatan", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Kelurahan", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              SizedBox(height: 5),
                                                                              TextView(headings: "H3", text: "Kode Pos", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              
                                                                            ]
                                                                          ),
                                                                          const SizedBox(width: 10),
                                                                          Expanded(
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                controller.listDataMAB[index].namaBelakang!="-" ?
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].namaDepan} ${controller.listDataMAB[index].namaBelakang}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start)
                                                                                :
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].namaDepan}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].jenisKelamin}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].tempatLahir}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${DateFormat("dd-MM-yyyy").format(DateTime.parse(controller.listDataMAB[index].tanggalLahir!))}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].noHp}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].alamat}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].provinsi}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].kota}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].kecamatan}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].kelurahan}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                                const SizedBox(height: 5),
                                                                                TextView(headings: "H3", text: ":  ${controller.listDataMAB[index].kodePos}", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                              ]
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Divider(color: Colors.grey.shade300, thickness: 3, height: 3, indent: 10, endIndent: 10),
                                                                    const SizedBox(height: 20),

                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Utils.decodeImage(controller.listDataMAB[index].stampPhoto.toString()),
                                                                              const TextView(headings: "H3", text: "Stamp Toko", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Utils.decodeImage(controller.listDataMAB[index].signature.toString()),
                                                                              const TextView(headings: "H3", text: "TTD", fontSize: 14, maxLines: 1, isAutoSize: true, textAlign: TextAlign.start),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child: ElevatedButton(
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.red.shade700,
                                                                                elevation: 5,
                                                                                padding: const EdgeInsets.all(16),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: const [                                                          
                                                                                  TextView(headings: "H2", text: "tolak", fontSize: 14, color: Colors.white, isCapslock: true),
                                                                                  SizedBox(width: 8),
                                                                                  FaIcon(FontAwesomeIcons.xmark, color: Colors.white, size: 20),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 20,),
                                                                          Expanded(
                                                                            child: ElevatedButton(
                                                                              onPressed: () async{
                                                                                await controller.approvalData(controller.listDataMAB[index].id.toString(), true);
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.teal.shade700,
                                                                                elevation: 5,
                                                                                padding: const EdgeInsets.all(16),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: const [                                                          
                                                                                  TextView(headings: "H2", text: "terima", fontSize: 14, color: Colors.white, isCapslock: true),
                                                                                  SizedBox(width: 8),
                                                                                  FaIcon(FontAwesomeIcons.checkToSlot, color: Colors.white, size: 20),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            );
                  
                                                            // Get.dialog(
                                                            //   Dialog(
                                                            //   backgroundColor: Colors.white,
                                                            //   shape: const RoundedRectangleBorder(
                                                            //       borderRadius: BorderRadius.all(Radius.circular(10))),
                                                            //   child: DialogConfirm(
                                                            //     message: "msg",
                                                            //     title: "title",
                                                            //     onTap: (){},
                                                            //   ))
                                                            // );
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