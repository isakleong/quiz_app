import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/cartheader.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/cartlist.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/productsearch.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/shoppingcart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TakingOrderVendorMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController =
      Get.put(TakingOrderVendorController());
  TakingOrderVendorMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        final width = ScreenUtil().screenWidth;
        final height = ScreenUtil().screenHeight;

        return Padding(
          padding: EdgeInsets.only(top: 0.035 * Get.height),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(() => SafeArea(
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/bg-homepage.svg',
                        fit: BoxFit.cover,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 0.05 * width,
                              top: 0.01 * height,
                            ),
                            child: BackButtonAction(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 0.05 * width,
                              top: 0.01 * height,
                            ),
                            child: ProductSearch(),
                          ),
                          if (_takingOrderVendorController
                                  .selectedValue.value !=
                              "")
                            Padding(
                              padding: EdgeInsets.only(
                                left: 0.05 * width,
                                top: 0.02 * height,
                              ),
                              child: Shoppingcart(),
                            ),
                          if (_takingOrderVendorController.cartList.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(
                                left: 0.05 * width,
                                top: 0.02 * height,
                                bottom: 0.01 * height,
                              ),
                              child: CartHeader(),
                            ),
                          if (_takingOrderVendorController.cartList.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                itemCount: _takingOrderVendorController
                                    .cartDetailList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 0.05 * width,
                                      top: 5,
                                      right: 0.05 * width,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        print((1 * width).toString());
                                        print(_takingOrderVendorController
                                            .cartDetailList[index].nmProduct
                                            .toString());
                                        _takingOrderVendorController
                                            .showProdukSerupa(
                                          _takingOrderVendorController
                                              .cartDetailList[index],
                                        );
                                      },
                                      child: CartList(
                                        idx: (index + 1).toString(),
                                        data: _takingOrderVendorController
                                            .cartDetailList[index],
                                      ),
                                    ),
                                  );
                                },
                                physics: const BouncingScrollPhysics(),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
