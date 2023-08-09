import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/returitem/noinputretur.dart';
import 'package:sfa_tools/screens/transaction/returitem/returheader.dart';
import 'package:sfa_tools/screens/transaction/returitem/shopcartservismebel.dart';
import 'package:sfa_tools/screens/transaction/returitem/tarikbaranglist.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class ServisMebel extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ServisMebel({super.key});

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
                          _takingOrderVendorController.servismebelfield.value,
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
                            .servismebelfield.value.text = "";
                      } else {
                        _takingOrderVendorController
                            .servismebelhorizontal.value = true;
                        _takingOrderVendorController
                            .servismebelfield.value.text = suggestion.nmProduct;
                        _takingOrderVendorController
                            .handleProductSearchSm(suggestion.kdProduct);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 0.01 * Get.height,
              ),
              _takingOrderVendorController.selectedProductservismebel.isEmpty
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(left: 0.05 * Get.width),
                      child: ShopCartServisMebel(),
                    ),
              _takingOrderVendorController.listServisMebel.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 0.02 * Get.height),
                      child: NoInputRetur(
                          image: 'assets/images/returservismebel.png',
                          title: "Belum Ada Produk Diservis",
                          isHorizontal: _takingOrderVendorController
                              .servismebelhorizontal.value,
                          description:
                              "Anda dapat mulai mencari produk yang akan diservis dan menambahkannya ke dalam keranjang."),
                    )
                  : Container(),
              _takingOrderVendorController.listServisMebel.isEmpty
                  ? Container()
                  : Expanded(
                      child: Column(
                      children: [
                        ReturHeader(
                            jumlahproduk:
                                "${_takingOrderVendorController.listServisMebel.length} Produk",
                            onTap: () {
                              _takingOrderVendorController
                                  .handleSaveServisMebel();
                            }),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _takingOrderVendorController
                                .listServisMebel.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.05 * Get.width,
                                      top: 5,
                                      right: 0.05 * Get.width),
                                  child: TarikBarangList(
                                    idx: (index + 1).toString(),
                                    data: _takingOrderVendorController
                                        .listServisMebel[index],
                                    onTapEdit: () {
                                      _takingOrderVendorController
                                          .handleEditServisMebelItem(
                                              _takingOrderVendorController
                                                  .listServisMebel[index]);
                                    },
                                    onTapDelete: () {
                                      _takingOrderVendorController
                                          .handleDeleteItemRetur(
                                              _takingOrderVendorController
                                                  .listServisMebel[index],
                                              "servismebel");
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
