import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/noinputretur.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/returheader.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/shopcartgantikemasan.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/tarikbaranglist.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class GantiKemasan extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  GantiKemasan({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 0.02 * Get.height, left: 0.05 * Get.width),
                child: SizedBox(
                  width: 0.9 * Get.width,
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller:
                          _takingOrderVendorController.gantikemasanfield.value,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
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
                            top: 0.01 * Get.height, bottom: 0.01 * Get.height),
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
                            .gantikemasanfield.value.text = "";
                      } else {
                        _takingOrderVendorController
                            .gantikemasanhorizontal.value = true;
                        _takingOrderVendorController.gantikemasanfield.value
                            .text = suggestion.nmProduct;
                        _takingOrderVendorController
                            .handleProductSearchGk(suggestion.kdProduct);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 0.01 * Get.height,
              ),
              _takingOrderVendorController.selectedProductgantikemasan.isEmpty
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(left: 0.05 * Get.width),
                      child: ShopCartGantiKemasan(),
                    ),
              _takingOrderVendorController.listgantikemasan.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 0.02 * Get.height),
                      child: NoInputRetur(
                          image: 'assets/images/returgantikemasan.png',
                          title: "Belum Ada Produk Diganti",
                          isHorizontal: _takingOrderVendorController
                              .gantikemasanhorizontal.value,
                          description:
                              "Anda dapat mulai mencari produk yang akan diganti dan menambahkannya ke dalam keranjang."),
                    )
                  : Container(),
              _takingOrderVendorController.listgantikemasan.isEmpty
                  ? Container()
                  : Expanded(
                      child: Column(
                      children: [
                        ReturHeader(
                            jumlahproduk:
                                "${_takingOrderVendorController.listgantikemasan.length} Produk",
                            onTap: () {
                              _takingOrderVendorController.handleSaveConfirm(
                                  "Yakin untuk simpan ganti kemasan?",
                                  "Konfirmasi Ganti Kemasan");
                            }),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _takingOrderVendorController
                                .listgantikemasan.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.05 * Get.width,
                                      top: 5,
                                      right: 0.05 * Get.width),
                                  child: TarikBarangList(
                                    idx: (index + 1).toString(),
                                    data: _takingOrderVendorController
                                        .listgantikemasan[index],
                                    onTapEdit: () {
                                      _takingOrderVendorController
                                          .handleEditGantiKemasanItem(
                                              _takingOrderVendorController
                                                  .listgantikemasan[index]);
                                    },
                                    onTapDelete: () {
                                      _takingOrderVendorController
                                          .handleDeleteItemRetur(
                                              _takingOrderVendorController
                                                  .listgantikemasan[index],
                                              "gantikemasan");
                                    },
                                  ));
                            },
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        )
                      ],
                    ))
            ],
          )),
    );
  }
}
