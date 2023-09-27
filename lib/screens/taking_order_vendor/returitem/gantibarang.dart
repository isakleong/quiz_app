import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/noinputretur.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/shopcartgantibarang.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/tarikbarangheader.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/tarikbaranglist.dart';
import 'package:sfa_tools/widgets/textview.dart';

class GantiBarang extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  GantiBarang({super.key});

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
                            _takingOrderVendorController.gantibarangfield.value,
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
                              .gantibarangfield.value.text = "";
                        } else {
                          _takingOrderVendorController
                              .gantibaranghorizontal.value = true;
                          _takingOrderVendorController.gantibarangfield.value
                              .text = suggestion.nmProduct;
                          _takingOrderVendorController
                              .handleProductSearchGb(suggestion.kdProduct);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.01 * height,
                ),
                _takingOrderVendorController
                        .selectedKdProductgantibarang.isEmpty
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 0.05 * width),
                        child: ShopCartGantiBarang(),
                      ),
                _takingOrderVendorController.listGantiBarang.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 0.02 * height),
                        child: NoInputRetur(
                            image: 'assets/images/returgantibarang.png',
                            title: "Belum Ada Produk Diganti",
                            isHorizontal: _takingOrderVendorController
                                .gantibaranghorizontal.value,
                            description:
                                "Anda dapat mulai mencari produk yang akan diganti dan menambahkannya ke dalam keranjang."),
                      )
                    : Container(),
                _takingOrderVendorController.listGantiBarang.isEmpty
                    ? Container()
                    : Expanded(
                        child: Column(
                        children: [
                          TarikBarangHeader(
                            onTap: () {
                              _takingOrderVendorController
                                  .handleSaveGantiBarang();
                            },
                            jumlahproduk:
                                "${_takingOrderVendorController.listGantiBarang.length} Produk",
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _takingOrderVendorController
                                  .listGantiBarang.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.05 * width,
                                        top: 5,
                                        right: 0.05 * width),
                                    child: TarikBarangList(
                                      idx: (index + 1).toString(),
                                      data: _takingOrderVendorController
                                          .listGantiBarang[index],
                                      onTapEdit: () {
                                        _takingOrderVendorController
                                            .handleEditGantiBarangItem(
                                                _takingOrderVendorController
                                                    .listGantiBarang[index]);
                                      },
                                      onTapDelete: () {
                                        _takingOrderVendorController
                                            .handleDeleteItemRetur(
                                                _takingOrderVendorController
                                                    .listGantiBarang[index],
                                                "gantibarang");
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
            )));
  }
}
