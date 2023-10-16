import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/produkpenggantiheader.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/shopcartprodukpengganti.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/tarikbaranglist.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';

import '../../../common/app_config.dart';
import '../../../widgets/textview.dart';

class BottomSheetTukarWarna extends StatelessWidget {
  String nmProduct;
  BottomSheetTukarWarna({super.key, required this.nmProduct});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FractionallySizedBox(
      heightFactor: 0.68,
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.minus,
                    size: 30,
                    color: Colors.grey.shade300,
                  ),
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
                              text: nmProduct,
                            )
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _takingOrderVendorController
                                        .listitemforProdukPengganti[0]
                                        .itemOrder
                                        .isNotEmpty
                                    ? ChipsItem(
                                        satuan:
                                            "${_takingOrderVendorController.listitemforProdukPengganti[0].itemOrder[0].Qty} ${_takingOrderVendorController.listitemforProdukPengganti[0].itemOrder[0].Satuan}")
                                    : Container(),
                                _takingOrderVendorController
                                            .listitemforProdukPengganti[0]
                                            .itemOrder
                                            .length >
                                        1
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: ChipsItem(
                                            satuan:
                                                "${_takingOrderVendorController.listitemforProdukPengganti[0].itemOrder[1].Qty} ${_takingOrderVendorController.listitemforProdukPengganti[0].itemOrder[1].Satuan}"),
                                      )
                                    : Container(),
                                _takingOrderVendorController
                                            .listitemforProdukPengganti[0]
                                            .itemOrder
                                            .length >
                                        2
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: ChipsItem(
                                            satuan:
                                                "${_takingOrderVendorController.listitemforProdukPengganti[0].itemOrder[2].Qty} ${_takingOrderVendorController.listitemforProdukPengganti[0].itemOrder[2].Satuan}"),
                                      )
                                    : Container()
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.02 * height),
                    child: SizedBox(
                      width: 0.9 * width,
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _takingOrderVendorController
                              .produkpenggantifield.value,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Cari Produk Pengganti',
                              labelStyle: TextStyle(fontSize: 16),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: Color(0XFF398f3e),
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
                          // ignore: unrelated_type_equality_checks
                          if (suggestion == "") {
                            _takingOrderVendorController
                                .produkpenggantifield.value.text = "";
                          } else {
                            _takingOrderVendorController.produkpenggantifield
                                .value.text = suggestion.nmProduct;
                            _takingOrderVendorController
                                .handleProductSearchretur(suggestion.kdProduct, 'pp');
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.01 * height,
                  ),
                  _takingOrderVendorController
                          .selectedProductProdukPengganti.isEmpty
                      ? Container()
                      : ShopCartProdukPenganti(),
                  _takingOrderVendorController.listProdukPengganti.isEmpty
                      ? Container()
                      : ProdukPenggantiHeader(
                          list: _takingOrderVendorController.listSisa,
                          ontap: () async {
                            await _takingOrderVendorController
                                .handlesaveprodukpengganti(context);
                          }),
                  _takingOrderVendorController.listProdukPengganti.isEmpty
                      ? Container()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _takingOrderVendorController
                                .listProdukPengganti.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.05 * width,
                                      top: 5,
                                      right: 0.05 * width),
                                  child: TarikBarangList(
                                    btndelete: const Color(0xFFe43936),
                                    unit: const Color(0xFFe43936),
                                    idx: (index + 1).toString(),
                                    data: _takingOrderVendorController
                                        .listProdukPengganti[index],
                                    onTapEdit: () {
                                      _takingOrderVendorController
                                          .handleEditItemRetur(
                                              _takingOrderVendorController
                                                  .listProdukPengganti[index],'pp');
                                    },
                                    onTapDelete: () {
                                      _takingOrderVendorController
                                          .handleDeleteItemRetur(
                                              _takingOrderVendorController
                                                  .listProdukPengganti[index],
                                              "produkpengganti");
                                    },
                                  ));
                            },
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        )
                ],
              ))),
    );
  }
}
