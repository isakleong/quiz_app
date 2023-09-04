import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(()=>Column(
        children: [
        Container(
          height: 0.2 * Get.height,
          width: Get.width,
          child: CarouselSlider(
            items: imgpath.map((imagePath) {
              return Container(
                    width: 0.8 * MediaQuery.of(context).size.width, // 70% of screen width
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      child: Image.file(
                        File('${basepath}${imagePath}'),
                        fit: BoxFit.fill, // Adjust the fit as needed
                      ),
                    ),
                  );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                _takingOrderVendorController.indicatorIndex.value = index;
              },
            ),
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgpath.map((image) {
            int index = imgpath.indexOf(image);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _takingOrderVendorController.indicatorIndex.value == index
                    ? AppConfig.mainCyan
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 10,),
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
        SizedBox(height: 5,),
        Expanded(child: 
        Padding(
          padding: const EdgeInsets.only(left: 40,right: 40),
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 15,bottom: 40),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.752,mainAxisSpacing: 20,crossAxisSpacing: 40), 
          itemBuilder: (context, index) {
            return Material(
              elevation: 1.2,
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.width < 450 ? 105.sp : 170.sp,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(File('${basepath}050_T_AAIP_23.jpg')),fit: BoxFit.fill)
                        ,borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                          decoration: BoxDecoration(color: Colors.grey.shade900.withOpacity(0.7)),
                          child: TextView(text: imgpath[0],color: Colors.white,fontSize: 11.sp,),
                        )
                      ),
                    ),
                  ),
                Material(
                   color: Colors.white,
                   elevation: 0,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)),
                    child: Column(children: [
                      SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.only(left: 12,right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(FontAwesomeIcons.calendarDays, color: Colors.green.shade600,size: 14.sp,)
                            ,SizedBox(width: 6.sp,),
                            TextView(text: '16 Jul - 18 Agu',fontSize: 11.sp,)
                        ],),
                      ),
                      SizedBox(height: 7.sp,),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(FontAwesomeIcons.clock, color: Colors.blue.shade600,size: 14.sp,),
                            SizedBox(width: 6.sp,),
                            TextView(text: "Sisa 14 Hari Lagi",fontSize: 10.sp,)
                        ],),
                      ),
                      SizedBox(height: 12.sp,)
                    ]),
                  )
              ]),
            );
          }),
        ))
      ])) 
    );
  }
}