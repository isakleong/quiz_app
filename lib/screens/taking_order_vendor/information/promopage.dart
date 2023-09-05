import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class PromoPage extends StatelessWidget {
   PromoPage({super.key});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

String basepath = '/storage/emulated/0/SFAPromo/';

List<String> imgpath  = [
  '001A_T_AA_23.jpg',
  '04_TRO-1B_Retailer_BBS_23.jpg',
  '04_TRO-2_Retailer_BBS_23.jpg',
  '050_T_AA_23.jpg'
];

List<String> imgpromo = [
  '050_T_AAIP_23.jpg',
  '064_T_AA_23.jpg',
  '074A_T_AA_23.jpg',
  '067_T_AA_23.jpg',
  '080_R_AA_23.jpg',
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(()=> Column(
        children: [
        Container(
          width: Get.width,
          height: Get.width < 450 ? 145 : 170,
          margin: EdgeInsets.only(top: 10,bottom: 10),
          child: Swiper(
            autoplay: true,
            autoplayDelay: 6000,
            viewportFraction: Get.width < 450 ? 0.7 : 0.6,
            scale: Get.width < 450 ? 0.7 : 0.65,
            itemCount: imgpath.length,
            pagination: const SwiperPagination(
              margin: EdgeInsets.only(top: 20),
              builder: DotSwiperPaginationBuilder(color: Colors.grey, size: 8, activeColor: Colors.teal, activeSize: 12)
            ),
            itemBuilder: (context, index) {
              return InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(File('$basepath${imgpath[index]}'), fit: BoxFit.contain,),
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
              constraints: BoxConstraints(minWidth: 0.25 * Get.width,minHeight: 0.03 * Get.height),
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
        const SizedBox(height: 5),
        Expanded(
          child: Padding(
          padding: EdgeInsets.only(left: Get.width < 450 ? 40 : 60,right: Get.width < 450 ? 40 : 60),
          child: GridView.builder(
            itemCount: 5,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 20,childAspectRatio: 0.75,crossAxisSpacing: 40), 
          itemBuilder: (context, index) {
            return Material(
              elevation: 1.2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.width < 450 ? 105.sp : 170.sp,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(File('${basepath}${imgpromo[index]}')),fit: BoxFit.fill)
                        ,borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                          decoration: BoxDecoration(color: Colors.grey.shade900.withOpacity(0.7)),
                          child: TextView(text: imgpromo[index],color: Colors.white,fontSize: 11.sp,),
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12,right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.calendarDays, color: Colors.green.shade600,size: 14.sp,)
                              ,SizedBox(width: 6.sp,),
                              TextView(text: '16 Jul - 18 Agu',fontSize: 11.sp,)
                          ],),
                        ),Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.clock, color: Colors.blue.shade600,size: 14.sp,),
                              SizedBox(width: 6.sp,),
                              TextView(text: "Sisa 14 Hari Lagi",fontSize: 10.sp,)
                          ],),
                        ),
                    ]),
                  ),
              ]),
            );
          }),
        ))
      ])) 
    );
  }
}