import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/information/promopage.dart';
import 'package:sfa_tools/widgets/textview.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/backbuttonaction.dart';
import '../activitypage.dart';
import '../vendorlistpage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'infoprodukpage.dart';

class InformasiMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  InformasiMainPage({super.key});
  List pages = [
    const PromoPage(),
    InfoProdukPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bg-homepage.svg',
            fit: BoxFit.cover,
          ),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Padding(
                      padding: EdgeInsets.only(
                        left: 0.05 * width,
                        top: 0.01 * height,
                      ),
                      child: const BackButtonAction(),
                    ),
                Padding(
                    padding: EdgeInsets.only(
                      top: 0.025 * height
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: ToggleButtons(
                        isSelected: _takingOrderVendorController.selectedsegmentinformasi,
                        onPressed: (index) {
                          _takingOrderVendorController.handleselectedindeinformasi(index);
                        },
                        constraints: BoxConstraints(minWidth: 0.25 * Get.width,minHeight: 0.05 * Get.height),
                        borderColor: Colors.grey,
                        selectedBorderColor: AppConfig.mainCyan,
                        borderRadius: BorderRadius.circular(20.0),
                        borderWidth: 1.0,
                        selectedColor: AppConfig.mainCyan,
                        fillColor: const Color(0xFFe0f2f2),
                        children: [
                          'Promo',
                          'Info Produk',
                        ].map((item) => 
                        TextView(
                          text: item, textAlign: TextAlign.center,headings: 'H5',fontSize: 11.sp,
                            ))
                        .toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.03 * Get.height,),
                Expanded(child: pages[_takingOrderVendorController.indexSegmentinformasi.value])
              ],
            ),
          )
          ],
        )
      ),
    );
  }
}