import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      ])) 
    );
  }
}