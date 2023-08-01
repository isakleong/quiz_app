import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/cartheader.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/cartlist.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/productsearch.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/shoppingcart.dart';

class TakingOrderVendorMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController =
      Get.put(TakingOrderVendorController());
  TakingOrderVendorMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                        const Padding(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            child: BackButtonAction()),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * width, top: 0.02 * height),
                            child: ProductSearch()),
                        _takingOrderVendorController.selectedValue.value == ""
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: 0.05 * width, top: 0.02 * height),
                                child: Shoppingcart()),
                        _takingOrderVendorController.cartList.isEmpty
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: 0.05 * width,
                                    top: 0.02 * height,
                                    bottom: 0.01 * height),
                                child: CartHeader()),
                        _takingOrderVendorController.cartList.isEmpty
                            ? Container()
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: _takingOrderVendorController
                                      .cartDetailList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.05 * width,
                                          top: 5,
                                          right: 0.05 * width),
                                      child: CartList(
                                          idx: (index + 1).toString(),
                                          data: _takingOrderVendorController
                                              .cartDetailList[index]),
                                    );
                                  },
                                  physics: const BouncingScrollPhysics(),
                                ),
                              ),
                      ]),
                ],
              ),
            )));
  }
}
