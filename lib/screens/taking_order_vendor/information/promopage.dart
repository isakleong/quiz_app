import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../tools/utils.dart';
import '../../../tools/viewimage.dart';
import '../../../widgets/textview.dart';

class PromoPage extends StatelessWidget {
  PromoPage({super.key});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(children: [
          /* untuk menampilkan banner dan category
          Container(
            width: width,
            height: width < 450 ? 145 : 170,
            margin: const EdgeInsets.only(top: 10,bottom: 10),
            child: Swiper(
              autoplay: true,
              autoplayDelay: 6000,
              viewportFraction: width < 450 ? 0.7 : 0.6,
              scale: width < 450 ? 0.7 : 0.65,
              itemCount: _takingOrderVendorController.imgpath.length,
              pagination: const SwiperPagination(
                margin: EdgeInsets.only(top: 20),
                builder: DotSwiperPaginationBuilder(color: Colors.grey, size: 8, activeColor: Colors.teal, activeSize: 12)
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(File('${_takingOrderVendorController.basepath}${_takingOrderVendorController.imgpath[index]}'), fit: BoxFit.contain,),
                  ),
                );
              },
              ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
              child: ToggleButtons(
                isSelected: _takingOrderVendorController.selectedsegmentcategory,
                onPressed: (index) {
                  _takingOrderVendorController.handleselectedsegmentcategory(index);
                },
                constraints: BoxConstraints(minWidth: 0.25 * width,minHeight: 0.03 * height),
                borderColor: Colors.grey,
                selectedBorderColor: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(10.0),
                borderWidth: 1.0,
                selectedColor: Colors.grey.shade700,
                fillColor: Colors.grey.shade700,
                children: [
                  'Cat',
                  'Bahan Bangunan',
                  'Mebel',
                ].map((item) => 
                TextView(
                  text: item, textAlign: TextAlign.center,headings: 'H5',fontSize: 9.sp,
                  color: _takingOrderVendorController.indexselectedsegmentcategory.value == 0 && item == "Cat" ? Colors.white :
                  _takingOrderVendorController.indexselectedsegmentcategory.value == 1 && item == "Bahan Bangunan" ? Colors.white :
                  _takingOrderVendorController.indexselectedsegmentcategory.value == 2 && item == "Mebel" ? Colors.white : Colors.grey.shade500 ,
                  ))
              .toList(),
            ),
          ),
        */
          const SizedBox(height: 5),
          Obx(() => _takingOrderVendorController.isSuccess.value == false &&
                  _takingOrderVendorController.promodir.isEmpty
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                          child: Container(
                            width: 0.4 * width,
                            height: 0.3 * height,
                            color: Colors.white,
                            // Add any other child widgets you want inside the shimmering container
                          ),
                        ),Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                          child: Container(
                            width: 0.4 * width,
                            height: 0.3 * height,
                            color: Colors.white,
                            // Add any other child widgets you want inside the shimmering container
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.04 * height,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                          child: Container(
                            width: 0.4 * width,
                            height: 0.3 * height,
                            color: Colors.white,
                            // Add any other child widgets you want inside the shimmering container
                          ),
                        ),Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                          child: Container(
                            width: 0.4 * width,
                            height: 0.3 * height,
                            color: Colors.white,
                            // Add any other child widgets you want inside the shimmering container
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : _takingOrderVendorController.isSuccess.value && _takingOrderVendorController.promodir.isEmpty ? 
              Padding(
                padding:  EdgeInsets.only(top: 0.2 * height),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/notfound.json', width: width * 0.35),
                      const TextView(
                        text: "Tidak Ada promo",
                        headings: 'H4',
                        fontSize: 20,
                      )
                    ],
                  ),
                ),
              )  : Expanded(
                  child: Padding(
                  padding: EdgeInsets.only(
                      left: width < 450 ? 40 : 60,
                      right: width < 450 ? 40 : 60),
                  child: GridView.builder(
                      itemCount: _takingOrderVendorController.promodir.isEmpty
                          ? 0
                          : _takingOrderVendorController.promodir.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 40),
                      itemBuilder: (context, index) {
                        //olah nama file
                        var itemname = _takingOrderVendorController.promodir[index];
                        var unpipelined = itemname.split("|");
                        var filename = unpipelined[0].split("/")[1];
                        int ext = filename.lastIndexOf(".");
                        filename = filename.substring(0, ext);

                        //tampilan periode
                        List<String> dateStrings = unpipelined[1].split("&");
                        String formattedDate1 = Utils().formatDateToMonthAlias(dateStrings[0].split('=')[1]);
                        String formattedDate2 = Utils().formatDateToMonthAlias(dateStrings[1]);
                        String result = '$formattedDate1 - $formattedDate2';

                        // Hitung selisih hari
                        DateTime endDate = DateTime.parse(dateStrings[1]);
                        DateTime now = DateTime.now();
                        int differenceInDays = endDate.difference(now).inDays;
                        return InkWell(
                          onTap: () async {
                            if(await File("${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${unpipelined[0].replaceAll("%20", " ")}").exists()){
                                Get.to(ViewImageScreen("${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${unpipelined[0].replaceAll("%20", " ")}"));
                            } else {
                                Get.defaultDialog(
                                  radius: 6,
                                  barrierDismissible: true,
                                  title: "",
                                  titlePadding:
                                      const EdgeInsets.only(top: 0, bottom: 0),
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
                                      const Text("Informasi Belum Tersedia",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      const SizedBox(height: 25),
                                      Text("File belum dapat diunduh,",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontSize: 15,
                                              color: Colors.grey.shade800)),
                                      const SizedBox(height: 6),
                                      Text("mohon coba kembali lain waktu.",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontSize: 15,
                                              color: Colors.grey.shade800)),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                );
                            }
                          },
                          child: Material(
                            elevation: 1.2,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width,
                                    height: width < 450 ? 105.sp : 170.sp,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: File('${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${unpipelined[0].replaceAll("%20", " ")}').existsSync()
                                                ?
                                          DecorationImage(
                                              image: FileImage(File('${_takingOrderVendorController.productdir}/${_takingOrderVendorController.activevendor.toLowerCase()}/${unpipelined[0].replaceAll("%20", " ")}')),
                                              fit: BoxFit.fill) : const DecorationImage(image: AssetImage("assets/images/defaultpromo.jpg")),
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12))),
                                      child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            width: width,
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, bottom: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade900
                                                    .withOpacity(0.7)),
                                            child: TextView(
                                              text: filename.replaceAll("%20", " "),
                                              color: Colors.white,
                                              fontSize: 11.sp,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, right: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.calendarDays,
                                                  color: Colors.green.shade600,
                                                  size: 14.sp,
                                                ),
                                                SizedBox(
                                                  width: 6.sp,
                                                ),
                                                TextView(
                                                  text: result,
                                                  fontSize:  width > 450 ? 11.sp : 10.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, right: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.clock,
                                                  color: Colors.blue.shade600,
                                                  size: 14.sp,
                                                ),
                                                SizedBox(
                                                  width: 6.sp,
                                                ),
                                                TextView(
                                                  text:
                                                      'Sisa $differenceInDays hari Lagi',
                                                  fontSize: 10.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ]),
                          ),
                        );
                      }),
                )))
        ]));
  }
}
