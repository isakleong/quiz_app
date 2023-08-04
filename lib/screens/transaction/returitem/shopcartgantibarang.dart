import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/doubleunit.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/singleunit.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/tripleunit.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class ShopCartGantiBarang extends StatelessWidget {
  ShopCartGantiBarang({super.key});
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
                              .selectedProductgantibarang[0].nmProduct,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _takingOrderVendorController.addToCartGb();
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
                                        .listGantiBarang.isEmpty
                                    ? "Tambah"
                                    : _takingOrderVendorController
                                            .listGantiBarang
                                            .any((data) =>
                                                data.kdProduct ==
                                                _takingOrderVendorController
                                                    .selectedProductgantibarang[
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
              _takingOrderVendorController.selectedProductgantibarang.value[0]
                          .detailProduct.length ==
                      1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          SingleUnit(
                              satuan: _takingOrderVendorController
                                  .selectedProductgantibarang
                                  .value[0]
                                  .detailProduct[0]
                                  .satuan,
                              ctrl: _takingOrderVendorController.qty1gb.value,
                              onTapMinus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1gb.value,
                                    '-');
                              },
                              onTapPlus: () {
                                _takingOrderVendorController.handleAddMinusBtn(
                                    _takingOrderVendorController.qty1gb.value,
                                    '+');
                              })
                        ])
                  : _takingOrderVendorController.selectedProductgantibarang
                              .value[0].detailProduct.length ==
                          2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProductgantibarang
                                      .value[0]
                                      .detailProduct[0]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty1gb.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1gb.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty1gb.value,
                                            '+');
                                  }),
                              DoubleUnit(
                                  satuan: _takingOrderVendorController
                                      .selectedProductgantibarang
                                      .value[0]
                                      .detailProduct[1]
                                      .satuan,
                                  ctrl:
                                      _takingOrderVendorController.qty2gb.value,
                                  onTapMinus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2gb.value,
                                            '-');
                                  },
                                  onTapPlus: () {
                                    _takingOrderVendorController
                                        .handleAddMinusBtn(
                                            _takingOrderVendorController
                                                .qty2gb.value,
                                            '+');
                                  }),
                            ])
                      : _takingOrderVendorController.selectedProductgantibarang
                                  .value[0].detailProduct.length ==
                              3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductgantibarang
                                          .value[0]
                                          .detailProduct[0]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty1gb.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1gb.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty1gb.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductgantibarang
                                          .value[0]
                                          .detailProduct[1]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty2gb.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2gb.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty2gb.value,
                                                '+');
                                      }),
                                  TripleUnit(
                                      satuan: _takingOrderVendorController
                                          .selectedProductgantibarang
                                          .value[0]
                                          .detailProduct[2]
                                          .satuan,
                                      ctrl: _takingOrderVendorController
                                          .qty3gb.value,
                                      onTapMinus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3gb.value,
                                                '-');
                                      },
                                      onTapPlus: () {
                                        _takingOrderVendorController
                                            .handleAddMinusBtn(
                                                _takingOrderVendorController
                                                    .qty3gb.value,
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
