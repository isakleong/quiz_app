import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';
import '../takingordervendor/doubleunit.dart';
import '../takingordervendor/singleunit.dart';
import '../takingordervendor/tripleunit.dart';

class ShopCartTarikBarang extends StatelessWidget {
  ShopCartTarikBarang({super.key});
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
                              .selectedProducttarikbarang[0].nmProduct,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _takingOrderVendorController.addToCartTb();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.mainCyan,
                          elevation: 5,
                          fixedSize: Size(0.2 * width, 0.04 * height),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              const Icon(Icons.shopping_cart),
                              TextView(
                                text: _takingOrderVendorController
                                        .listTarikBarang.isEmpty
                                    ? "Tambah"
                                    : _takingOrderVendorController
                                            .listTarikBarang
                                            .any((data) =>
                                                data.kdProduct ==
                                                _takingOrderVendorController
                                                    .selectedProducttarikbarang[
                                                        0]
                                                    .kdProduct)
                                        ? "Ganti"
                                        : "Tambah",
                                headings: 'H4',
                                fontSize: 14,
                                color: Colors.white,
                              )
                            ])),
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
              _takingOrderVendorController.selectedProducttarikbarang.value[0]
                          .detailProduct.length ==
                      1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          SingleUnit(
                              satuan: _takingOrderVendorController
                                  .selectedProducttarikbarang
                                  .value[0]
                                  .detailProduct[0]
                                  .satuan,
                              ctrl: _takingOrderVendorController.qty1tb.value,
                              onTapMinus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1tb.value,
                                    '-');
                              },
                              onTapPlus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1tb.value,
                                    '+');
                              })
                        ])
                  : _takingOrderVendorController.selectedProducttarikbarang
                              .value[0].detailProduct.length ==
                          2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProducttarikbarang
                                      .value[0]
                                      .detailProduct[0]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty1tb.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1tb.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1tb.value,
                                            '+');
                                  }),
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProducttarikbarang
                                      .value[0]
                                      .detailProduct[1]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty2tb.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2tb.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2tb.value,
                                            '+');
                                  }),
                            ])
                      : _takingOrderVendorController.selectedProducttarikbarang
                                  .value[0].detailProduct.length ==
                              3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProducttarikbarang
                                          .value[0]
                                          .detailProduct[0]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty1tb.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1tb.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1tb.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProducttarikbarang
                                          .value[0]
                                          .detailProduct[1]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty2tb.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2tb.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2tb.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProducttarikbarang
                                          .value[0]
                                          .detailProduct[2]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty3tb.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3tb.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3tb.value,
                                                '+');
                                      })
                                ])
                          : Container(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 0.05 * Get.width,
                    right: 0.05 * Get.width,
                    bottom: 0.01 * Get.height),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade500)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _takingOrderVendorController
                                    .selectedAlasantb.value ==
                                ""
                            ? 'Pilih Alasan Retur'
                            : _takingOrderVendorController
                                .selectedAlasantb.value,
                        onChanged: (data) {
                          print(data);
                          _takingOrderVendorController.selectedAlasantb.value =
                              data!;
                        },
                        items: <String>[
                          'Pilih Alasan Retur',
                          'Cat Bau',
                          'Cat Menggumpal'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  value == 'Pilih Alasan Retur'
                                      ? FontAwesomeIcons.truck
                                      : FontAwesomeIcons.circleChevronRight,
                                  size: 18,
                                  color: AppConfig.mainCyan,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                TextView(
                                  text: value,
                                  textAlign: TextAlign.left,
                                  fontSize: 13,
                                  headings: 'H4',
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
