import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/doubleunit.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/singleunit.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/tripleunit.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../common/app_config.dart';

class ShopCartProdukPenganti extends StatelessWidget {
  ShopCartProdukPenganti({super.key});
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
                border: Border.all(color: Color(0XFF398f3e), width: 2),
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
                          color: Color(0XFF398f3e),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextView(
                          headings: 'H4',
                          fontSize: 14,
                          text: _takingOrderVendorController
                              .selectedProductProdukPengganti[0].nmProduct,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          _takingOrderVendorController.addToCartPp();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFF398f3e),
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
                            Icon(
                              FontAwesomeIcons.cartShopping,
                              size: 18,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            TextView(
                              text: _takingOrderVendorController
                                      .listProdukPengganti.isEmpty
                                  ? "Tambah"
                                  : _takingOrderVendorController
                                          .listProdukPengganti
                                          .any((data) =>
                                              data.kdProduct ==
                                              _takingOrderVendorController
                                                  .selectedProductProdukPengganti[
                                                      0]
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
                    ),
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
              _takingOrderVendorController.isOverfow.value
                  ? Padding(
                      padding: EdgeInsets.only(left: 0.02 * width, bottom: 8),
                      child: Container(
                        width: 0.86 * width,
                        decoration: BoxDecoration(
                            color: Color(0xFFc4185c),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: TextView(
                          text: "Melebihi batas kuantiti yang ditukar",
                          color: Colors.white,
                          headings: 'H4',
                        )),
                      ),
                    )
                  : Container(),
              _takingOrderVendorController.selectedProductProdukPengganti
                          .value[0].detailProduct.length ==
                      1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          SingleUnit(
                              satuan: _takingOrderVendorController
                                  .selectedProductProdukPengganti
                                  .value[0]
                                  .detailProduct[0]
                                  .satuan,
                              ctrl: _takingOrderVendorController.qty1pp.value,
                              colorChips: Color(0xFFe64a19),
                              onTapMinus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1pp.value,
                                    '-');
                              },
                              onTapPlus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1pp.value,
                                    '+');
                              })
                        ])
                  : _takingOrderVendorController.selectedProductProdukPengganti
                              .value[0].detailProduct.length ==
                          2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProductProdukPengganti
                                      .value[0]
                                      .detailProduct[0]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty1pp.value,
                                  colorChips: Color(0xFFe64a19),
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1pp.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1pp.value,
                                            '+');
                                  }),
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProductProdukPengganti
                                      .value[0]
                                      .detailProduct[1]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty2pp.value,
                                  colorChips: Color(0xFFe64a19),
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2pp.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2pp.value,
                                            '+');
                                  }),
                            ])
                      : _takingOrderVendorController
                                  .selectedProductProdukPengganti
                                  .value[0]
                                  .detailProduct
                                  .length ==
                              3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductProdukPengganti
                                          .value[0]
                                          .detailProduct[0]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty1pp.value,
                                      colorChips: Color(0xFFe64a19),
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1pp.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1pp.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductProdukPengganti
                                          .value[0]
                                          .detailProduct[1]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty2pp.value,
                                      colorChips: Color(0xFFe64a19),
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2pp.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2pp.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductProdukPengganti
                                          .value[0]
                                          .detailProduct[2]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty3pp.value,
                                      colorChips: Color(0xFFe64a19),
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3pp.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3pp.value,
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
