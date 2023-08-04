import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../common/app_config.dart';

class ProductSearch extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ProductSearch({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() => Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: SizedBox(
            width: 0.9 * width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppConfig.mainCyan,
                          ),
                        ),
                        Image.asset(
                          'assets/images/custorder.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextView(
                            headings: "H2", text: "Penjualan", fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppConfig.mainCyan,
                                  ),
                                ),
                                const Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 15,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("Adek Abang"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.02 * width),
                child: Container(
                  width: 0.86 * width,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 0.02 * width, top: 5, bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 0.8 * width,
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _takingOrderVendorController.cnt.value,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                              labelText: 'Cari Produk',
                              labelStyle: TextStyle(fontSize: 16),
                              border: InputBorder.none,
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
                          // print(suggestion);
                          if (suggestion == "") {
                            _takingOrderVendorController.cnt.value.text = "";
                          } else {
                            _takingOrderVendorController.cnt.value.text =
                                suggestion.nmProduct;
                            _takingOrderVendorController
                                .handleProductSearchButton(
                                    suggestion.kdProduct);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
