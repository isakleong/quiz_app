import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/noinputretur.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/returheader.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/shopcarttukarwarna.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/tukarwarnalist.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class TukarWarnaPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  TukarWarnaPage({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 0.02 * height, left: 0.05 * width),
                  child: SizedBox(
                    width: 0.9 * width,
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller:
                            _takingOrderVendorController.tukarwarnafield.value,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                            labelText: 'Cari Produk',
                            labelStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.magnifyingGlass,
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
                              top: 0.01 * height,
                              bottom: 0.01 * height),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 0.02 * width,
                              ),
                              Icon(
                                FontAwesomeIcons.solidCircle,
                                color: Colors.grey.shade600,
                                size: 14,
                              ),
                              SizedBox(
                                width: 0.02 * width,
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
                              .tukarwarnafield.value.text = "";
                        } else {
                          _takingOrderVendorController
                              .tukarwarnahorizontal.value = true;
                          _takingOrderVendorController.tukarwarnafield.value
                              .text = suggestion.nmProduct;
                          _takingOrderVendorController.handleProductSearchretur(suggestion.kdProduct, 'tw');
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.01 * height,
                ),
                _takingOrderVendorController.selectedProductTukarWarna.isEmpty
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 0.05 * width),
                        child: ShopCartTukarWarna(),
                      ),
                _takingOrderVendorController.listTukarWarna.isEmpty
                    ? Container()
                    : Expanded(
                        child: Column(
                          children: [
                            ReturHeader(
                                jumlahproduk:
                                    "${_takingOrderVendorController.listTukarWarna.length} Produk",
                                onTap: () {
                                  _takingOrderVendorController
                                      .handleSaveConfirm(
                                          "Yakin untuk simpan tukar warna ?",
                                          "Konfirmasi Tukar Warna", (){Get.back();});
                                }),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _takingOrderVendorController
                                    .listTukarWarna.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.05 * width,
                                          top: 5,
                                          right: 0.05 * width),
                                      child: TukarWarnaList(
                                        idx: (index + 1).toString(),
                                        data: _takingOrderVendorController
                                            .listTukarWarna[index],
                                        onTapEdit: () {
                                          _takingOrderVendorController
                                              .handleEditItemRetur(
                                                  _takingOrderVendorController
                                                      .listTukarWarna[index],'tw');
                                        },
                                        onTapDelete: () {
                                          _takingOrderVendorController
                                              .handleDeleteItemRetur(
                                                  _takingOrderVendorController
                                                      .listTukarWarna[index],'tw');
                                        },
                                      ));
                                },
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                              ),
                            )
                          ],
                        ),
                      ),
                _takingOrderVendorController.listTukarWarna.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: 0.02 * height,
                        ),
                        child: NoInputRetur(
                            image: 'assets/images/returtukarwarna.png',
                            isHorizontal: _takingOrderVendorController
                                .tukarwarnahorizontal.value,
                            title: "Belum Ada Produk Ditukar",
                            description:
                                "Anda dapat mulai mencari produk yang akan ditukar dan menambahkannya ke dalam keranjang."),
                      )
                    : Container()
              ],
            )));
  }
}
