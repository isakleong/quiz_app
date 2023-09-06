import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/doubleunit.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/singleunit.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/tripleunit.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class Shoppingcart extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  Shoppingcart({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Container(
        width: 0.9 * width,
        decoration: BoxDecoration(
            border: Border.all(color: AppConfig.mainCyan, width: 2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_mosaic_rounded,
                      color: AppConfig.mainCyan,
                      size: 12.sp,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextView(
                      headings: 'H4',
                      maxLines: 1,
                      fontSize: 10.sp,
                      textAlign: TextAlign.left,
                      text: _takingOrderVendorController
                          .selectedProduct[0].nmProduct,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_takingOrderVendorController
                          .cartDetailList.isNotEmpty) {
                        if (_takingOrderVendorController.cartList.any((data) =>
                            data.kdProduct ==
                            _takingOrderVendorController
                                .selectedProduct[0].kdProduct)) {
                          _takingOrderVendorController.updateCart();
                        } else {
                          _takingOrderVendorController.addToCart();
                        }
                      } else {
                        _takingOrderVendorController.addToCart();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.mainCyan,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.only(
                        left: 10.sp,
                        right: 10.sp,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 12.sp,
                        ),
                        const SizedBox(
                            width:
                                8), // Add some space between the icon and text
                        TextView(
                          text: _takingOrderVendorController.cartList.isEmpty
                              ? "Tambah"
                              : _takingOrderVendorController.cartList.any(
                                      (data) =>
                                          data.kdProduct ==
                                          _takingOrderVendorController
                                              .selectedProduct[0].kdProduct)
                                  ? "Ganti"
                                  : "Tambah",
                          headings: 'H4',
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.02 * width),
            child: Container(
              width: 0.86 * width,
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(() => _takingOrderVendorController
                      .selectedProduct.value[0].detailProduct.length ==
                  1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      SingleUnit(
                          satuan: _takingOrderVendorController
                              .selectedProduct.value[0].detailProduct[0].satuan,
                          ctrl: _takingOrderVendorController.qty1.value,
                          onTapMinus: () {
                            _takingOrderVendorController.handleAddMinusBtn(
                                _takingOrderVendorController.qty1.value, '-');
                          },
                          onTapPlus: () {
                            _takingOrderVendorController.handleAddMinusBtn(
                                _takingOrderVendorController.qty1.value, '+');
                          })
                    ])
              : _takingOrderVendorController
                          .selectedProduct.value[0].detailProduct.length ==
                      2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          DoubleUnit(
                              satuan: _takingOrderVendorController
                                  .selectedProduct
                                  .value[0]
                                  .detailProduct[0]
                                  .satuan,
                              ctrl: _takingOrderVendorController.qty1.value,
                              onTapMinus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1.value,
                                    '-');
                              },
                              onTapPlus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1.value,
                                    '+');
                              }),
                          DoubleUnit(
                              satuan: _takingOrderVendorController
                                  .selectedProduct
                                  .value[0]
                                  .detailProduct[1]
                                  .satuan,
                              ctrl: _takingOrderVendorController.qty2.value,
                              onTapMinus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty2.value,
                                    '-');
                              },
                              onTapPlus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty2.value,
                                    '+');
                              }),
                        ])
                  : _takingOrderVendorController
                              .selectedProduct.value[0].detailProduct.length ==
                          3
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              TripleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProduct
                                      .value[0]
                                      .detailProduct[0]
                                      .satuan,
                                  ctrl: _takingOrderVendorController.qty1.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1.value,
                                            '+');
                                  }),
                              TripleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProduct
                                      .value[0]
                                      .detailProduct[1]
                                      .satuan,
                                  ctrl: _takingOrderVendorController.qty2.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2.value,
                                            '+');
                                  }),
                              TripleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProduct
                                      .value[0]
                                      .detailProduct[2]
                                      .satuan,
                                  ctrl: _takingOrderVendorController.qty3.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty3.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty3.value,
                                            '+');
                                  })
                            ])
                      : Container()),
          const SizedBox(
            height: 15,
          )
        ]),
      ),
    );
  }
}
