import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/payment/paymentheader.dart';
import 'package:sfa_tools/screens/transaction/returitem/noinputretur.dart';
import 'package:sfa_tools/screens/transaction/returitem/shopcarttarikbarang.dart';
import 'package:sfa_tools/screens/transaction/returitem/tarikbarangheader.dart';
import 'package:sfa_tools/screens/transaction/returitem/tarikbaranglist.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import '../takingordervendor/cartheader.dart';
import '../takingordervendor/cartlist.dart';

class TarikBarangPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  TarikBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 0.02 * Get.height, left: 0.05 * Get.width),
                  child: Container(
                    width: 0.9 * Get.width,
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller:
                            _takingOrderVendorController.tarikbarangfield.value,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                            labelText: 'Cari Produk',
                            labelStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.search,
                              color: Color(0XFF319088),
                            )),
                      ),
                      suggestionsCallback: (pattern) {
                        return _takingOrderVendorController.listProduct
                            .where((data) => data.nmProduct
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 0.01 * Get.height,
                              bottom: 0.01 * Get.height),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 0.02 * Get.width,
                              ),
                              Icon(
                                FontAwesomeIcons.solidCircle,
                                color: Colors.grey.shade600,
                                size: 14,
                              ),
                              SizedBox(
                                width: 0.02 * Get.width,
                              ),
                              TextView(
                                text: suggestion.nmProduct,
                                fontSize: 15,
                              ),
                            ],
                          ),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        if (suggestion == "") {
                          _takingOrderVendorController
                              .tarikbarangfield.value.text = "";
                        } else {
                          _takingOrderVendorController
                              .tarikbaranghorizontal.value = true;
                          _takingOrderVendorController.tarikbarangfield.value
                              .text = suggestion.nmProduct;
                          _takingOrderVendorController
                              .handleProductSearchTb(suggestion.kdProduct);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.01 * Get.height,
                ),
                _takingOrderVendorController
                            .selectedKdProducttarikbarang.value ==
                        ""
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 0.05 * Get.width),
                        child: ShopCartTarikBarang(),
                      ),
                _takingOrderVendorController.listTarikBarang.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 0.02 * Get.height),
                        child: NoInputRetur(
                            image: 'assets/images/returtarikbarang.png',
                            title: "Belum Ada Produk Ditarik",
                            isHorizontal: _takingOrderVendorController
                                .tarikbaranghorizontal.value,
                            description:
                                "Anda dapat mulai mencari produk yang akan ditarik dan menambahkannya ke dalam keranjang."),
                      )
                    : Container(),
                _takingOrderVendorController.listTarikBarang.isEmpty
                    ? Container()
                    : Expanded(
                        child: Column(
                        children: [
                          TarikBarangHeader(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _takingOrderVendorController
                                  .listTarikBarang.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.05 * Get.width,
                                        top: 5,
                                        right: 0.05 * Get.width),
                                    child: TarikBarangList(
                                        idx: (index + 1).toString(),
                                        data: _takingOrderVendorController
                                            .listTarikBarang[index]));
                              },
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                            ),
                          )
                        ],
                      ))
              ],
            )));
  }
}
