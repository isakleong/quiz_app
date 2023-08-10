import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class DialogProdukSerupa extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  DialogProdukSerupa({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.8,
      height: 0.7 * Get.height,
      child: Column(
        children: [
          if (Get.width > 450)
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                right: 0.025 * Get.width,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.2 * Get.width),
                    child: TextView(
                      text: "Produk Serupa",
                      headings: 'H3',
                      fontSize: 11.sp,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.mainCyan,
                      elevation: 5,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Icon(FontAwesomeIcons.close,
                        size: 18.sp, color: Colors.white),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                right: 0.025 * Get.width,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.125 * Get.width),
                    child: TextView(
                      text: "Produk Serupa",
                      headings: 'H3',
                      fontSize: 11.sp,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.mainCyan,
                      elevation: 5,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.all(8.sp),
                    ),
                    child: Icon(FontAwesomeIcons.close,
                        size: 18.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: 8,
              left: 0.05 * Get.width,
              right: 0.05 * Get.width,
            ),
            child: Container(
              height: 1.5,
              color: Colors.grey.shade400,
            ),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.05 * Get.width,
                      right: 0.05 * Get.width,
                      bottom: 15),
                  child: ListView.builder(
                      itemCount:
                          _takingOrderVendorController.listProduct.length,
                      itemBuilder: (c, i) {
                        return InkWell(
                          onTap: () {
                            _takingOrderVendorController.cnt.value.text =
                                _takingOrderVendorController
                                    .listProduct[i].nmProduct;
                            _takingOrderVendorController
                                .handleProductSearchButton(
                                    _takingOrderVendorController
                                        .listProduct[i].kdProduct);
                            Get.back();
                          },
                          child: Container(
                            width: 0.7 * Get.width,
                            color:
                                i % 2 == 0 ? Colors.white : Color(0XFFe0f2f2),
                            child: Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(children: [
                                SizedBox(
                                  width: 0.01 * Get.width,
                                ),
                                Icon(
                                  FontAwesomeIcons.circleChevronRight,
                                  size: 8.5.sp,
                                  color: AppConfig.mainCyan,
                                ),
                                SizedBox(
                                  width: 0.02 * Get.width,
                                ),
                                if (Get.width > 450)
                                  TextView(
                                    text: _takingOrderVendorController
                                        .listProduct[i].nmProduct,
                                    fontSize: 10.sp,
                                  )
                                else
                                  Container(
                                    height: 0.02 * Get.height,
                                    child: FittedBox(
                                      child: TextView(
                                        text: _takingOrderVendorController
                                            .listProduct[i].nmProduct,
                                      ),
                                    ),
                                  )
                              ]),
                            ),
                          ),
                        );
                      })))
        ],
      ),
    );
  }
}
