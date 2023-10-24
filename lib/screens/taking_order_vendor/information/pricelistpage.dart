import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/tools/viewimage.dart';
import 'package:sfa_tools/tools/viewpdf.dart';
import 'package:sfa_tools/tools/viewvideo.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class PriceListPage extends StatelessWidget {
  PriceListPage({super.key});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _takingOrderVendorController.isSuccess.value &&
                  _takingOrderVendorController.pricelistdir.isEmpty
              ? Padding(
                padding: EdgeInsets.only(top: 0.2 * height),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/notfound.json',
                            width: width * 0.35),
                        const TextView(
                          text: "Tidak Ada Pricelist",
                          headings: 'H4',
                          fontSize: 20,
                        )
                      ],
                    ),
                  ),
              )
              : Column(
                  children: [
                    SizedBox(
                      height: 0.01 * height,
                    ),
                    Obx(() => Expanded(
                            child: ListView.builder(
                          itemBuilder: (c, i) {
                            if (_takingOrderVendorController.isSuccess.value) {
                              var filedir =
                                  _takingOrderVendorController.pricelistdir[i];
                              var splitteddir = filedir.split("/");
                              var nmfile = splitteddir[splitteddir.length - 1]
                                  .replaceAll("%20", " ");
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 0.05 * width, bottom: 0.025 * height),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () async {
                                      var ext = "";
                                      int lastDotIndex =
                                          nmfile.lastIndexOf('.');
                                      if (lastDotIndex != -1 &&
                                          lastDotIndex < nmfile.length - 1) {
                                        ext =
                                            nmfile.substring(lastDotIndex + 1);
                                      }
                                      if (await File(
                                              "${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${filedir.replaceAll("%20", " ")}")
                                          .exists()) {
                                        if (ext == "jpg" || ext == "jpeg") {
                                          Get.to(ViewImageScreen(
                                              "${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${filedir.replaceAll("%20", " ")}"));
                                        } else if (ext == "pdf") {
                                          Get.to(ViewPDFScreen(
                                              "${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${filedir.replaceAll("%20", " ")}"));
                                        } else if (ext == "mp4") {
                                          Get.to(ViewVideoScreen(
                                              "${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${filedir.replaceAll("%20", " ")}"));
                                        }
                                      } else {
                                        Get.defaultDialog(
                                          radius: 6,
                                          barrierDismissible: true,
                                          title: "",
                                          titlePadding: const EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          cancel: OutlinedButton(
                                            onPressed: () => {Get.back()},
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors.teal),
                                            child: const Text("TUTUP",
                                                style: TextStyle(
                                                    fontFamily: "Lato",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                              bottom: 15, left: 20, right: 20),
                                          content: Column(
                                            children: [
                                              const Text(
                                                  "Informasi Belum Tersedia",
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              const SizedBox(height: 25),
                                              Text("File belum dapat diunduh,",
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey.shade800)),
                                              const SizedBox(height: 6),
                                              Text(
                                                  "mohon coba kembali lain waktu.",
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey.shade800)),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 0.07 * width,
                                          height: 0.07 * width,
                                          decoration: const BoxDecoration(
                                            color: Colors.blueGrey,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: TextView(
                                              text: (i + 1).toString(),
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              headings: 'H2',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 0.02 * width,
                                        ),
                                        Image.asset("assets/images/filepdf.png",
                                            height: 25.sp),
                                        SizedBox(
                                          width: 0.02 * width,
                                        ),
                                        AutoSizeText(
                                          nmfile,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      450
                                                  ? 9.sp
                                                  : 11.sp,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    left: 0.05 * width,
                                    right: 0.05 * width),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade400,
                                  highlightColor: Colors.grey.shade200,
                                  child: Container(
                                    width: 0.8 * width,
                                    height: 0.05 * height,
                                    color: Colors.white,
                                    // Add any other child widgets you want inside the shimmering container
                                  ),
                                ),
                              );
                            }
                          },
                          itemCount:
                              _takingOrderVendorController.isSuccess.value ==
                                      false
                                  ? 10
                                  : _takingOrderVendorController
                                          .pricelistdir.isEmpty
                                      ? 0
                                      : _takingOrderVendorController
                                          .pricelistdir.length,
                          physics: const BouncingScrollPhysics(),
                        )))
                  ],
                )
        ],
      ),
    );
  }
}
