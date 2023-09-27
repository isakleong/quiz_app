import 'package:flutter/material.dart';
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.8,
      height: 0.7 * height,
      child: Column(
        children: [
          if (width > 450)
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                right: 0.025 * width,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.2 * width),
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
                    child: Icon(FontAwesomeIcons.xmark,
                        size: 18.sp, color: Colors.white),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                right: 0.025 * width,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.125 * width),
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
                    child: Icon(FontAwesomeIcons.xmark,
                        size: 18.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: 8,
              left: 0.05 * width,
              right: 0.05 * width,
            ),
            child: Container(
              height: 1.5,
              color: Colors.grey.shade400,
            ),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 0.05 * width,
                      right: 0.05 * width,
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
                            width: 0.7 * width,
                            color:
                                i % 2 == 0 ? Colors.white : const Color(0XFFe0f2f2),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(children: [
                                SizedBox(
                                  width: 0.01 * width,
                                ),
                                Icon(
                                  FontAwesomeIcons.circleChevronRight,
                                  size: 8.5.sp,
                                  color: AppConfig.mainCyan,
                                ),
                                SizedBox(
                                  width: 0.02 * width,
                                ),
                                if (width > 450)
                                  TextView(
                                    text: _takingOrderVendorController
                                        .listProduct[i].nmProduct,
                                    fontSize: 10.sp,
                                  )
                                else
                                  SizedBox(
                                    height: 0.02 * height,
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
