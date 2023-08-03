import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/returitem/noinputretur.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class TukarWarnaPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  TukarWarnaPage({super.key});

  final List<String> countries = [
    'Argentina',
    'Brazil',
    'Canada',
    'Denmark',
    'France',
    'Germany',
    'India',
    'Japan',
    'United States',
    'United Kingdom',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0.02 * Get.height),
          child: Container(
            width: 0.9 * Get.width,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _takingOrderVendorController.tukarwarnafield.value,
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
                return countries
                    .where((country) =>
                        country.toLowerCase().contains(pattern.toLowerCase()))
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
                        text: suggestion,
                        fontSize: 15,
                      ),
                    ],
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                _takingOrderVendorController.tukarwarnafield.value.text =
                    suggestion;
                print('Selected: $suggestion');
              },
            ),
          ),
        ),
        SizedBox(
          height: 0.02 * Get.height,
        ),
        NoInputRetur(
            image: 'assets/images/returtukarwarna.png',
            isHorizontal:
                _takingOrderVendorController.tukarwarnahorizontal.value,
            title: "Belum Ada Produk Ditukar",
            description:
                "Anda dapat mulai mencari produk yang akan ditukar dan menambahkannya ke dalam keranjang.")
      ],
    );
  }
}
