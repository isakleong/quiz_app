import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/doubleunit.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/tripleunit.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';
import '../takingordervendor/singleunit.dart';

class ShopCartServisMebel extends StatelessWidget {
  ShopCartServisMebel({super.key});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;
    return Obx(() => Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Container(
            width: 0.9 * width,
            decoration: BoxDecoration(
                border: Border.all(color: AppConfig.mainCyan, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextView(
                          headings: 'H4',
                          fontSize: 14,
                          text: _takingOrderVendorController
                              .selectedProductservismebel[0].nmProduct,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _takingOrderVendorController.addToCartSm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.mainCyan,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 2, bottom: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart),
                            const SizedBox(
                                width:
                                    8), // Add some space between the icon and text
                            TextView(
                              text: _takingOrderVendorController
                                      .listServisMebel.isEmpty
                                  ? "Tambah"
                                  : _takingOrderVendorController.listServisMebel
                                          .any((data) =>
                                              data.kdProduct ==
                                              _takingOrderVendorController
                                                  .selectedProductservismebel[0]
                                                  .kdProduct)
                                      ? "Ganti"
                                      : "Tambah",
                              headings: 'H4',
                              fontSize: 14,
                              color: Colors.white,
                            )
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
              _takingOrderVendorController.selectedProductservismebel.value[0]
                          .detailProduct.length ==
                      1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          SingleUnit(
                              satuan: _takingOrderVendorController
                                  .selectedProductservismebel
                                  .value[0]
                                  .detailProduct[0]
                                  .satuan,
                              ctrl: _takingOrderVendorController.qty1sm.value,
                              onTapMinus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1sm.value,
                                    '-');
                              },
                              onTapPlus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1sm.value,
                                    '+');
                              })
                        ])
                  : _takingOrderVendorController.selectedProductservismebel
                              .value[0].detailProduct.length ==
                          2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProductservismebel
                                      .value[0]
                                      .detailProduct[0]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty1sm.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1sm.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1sm.value,
                                            '+');
                                  }),
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProductservismebel
                                      .value[0]
                                      .detailProduct[1]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty2sm.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2sm.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2sm.value,
                                            '+');
                                  }),
                            ])
                      : _takingOrderVendorController.selectedProductservismebel
                                  .value[0].detailProduct.length ==
                              3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductservismebel
                                          .value[0]
                                          .detailProduct[0]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty1sm.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1sm.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1sm.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductservismebel
                                          .value[0]
                                          .detailProduct[1]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty2sm.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2sm.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2sm.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductservismebel
                                          .value[0]
                                          .detailProduct[2]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty3sm.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3sm.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3sm.value,
                                                '+');
                                      })
                                ])
                          : Container(),
              const SizedBox(
                height: 15,
              ),
            ]),
          ),
        ));
  }
}
