import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
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
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * width,
        height: 0.15 * height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    const TextView(headings: "H2", text: "Penjualan", fontSize: 14),
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
            padding: EdgeInsets.only(left: 0.02 * width, top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppConfig.mainCyan,
                  size: 35,
                ),
                const SizedBox(
                  width: 10,
                ),
                Obx(
                  () => SizedBox(
                    width: 0.8 * width,
                    height: 0.045 * height,
                    child: DropDownTextField(
                        clearOption: false,
                        enableSearch: true,
                        dropDownIconProperty: IconProperty(icon: null),
                        controller: _takingOrderVendorController.cnt,
                        textFieldDecoration: const InputDecoration(
                            hintText: "Cari Produk", border: InputBorder.none),
                        searchDecoration: const InputDecoration(
                            hintText: "Ketik nama produk"),
                        dropDownItemCount:
                            _takingOrderVendorController.listDropDown.length,
                        dropDownList: _takingOrderVendorController.listDropDown,
                        onChanged: (val) {
                          if (val != "") {
                            _takingOrderVendorController
                                .handleProductSearchButton(
                                    val.value.toString());
                          } else {
                            _takingOrderVendorController.selectedValue.value =
                                '';
                          }
                        }),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
