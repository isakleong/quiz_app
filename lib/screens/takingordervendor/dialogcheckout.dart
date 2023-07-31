import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/takingordervendor/checkoutlist.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../common/app_config.dart';

class DialogCheckOut extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  DialogCheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.9,
      height: 0.85 * Get.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.03,
            ),
            TextView(
              text: "Penjualan - Adek Abang",
              headings: 'H3',
              fontSize: 17,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            TextView(
              text: "Alamat Pengiriman",
              headings: 'H3',
              fontSize: 15,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Container(
              width: 0.8 * Get.width,
              height: 0.05 * Get.height,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.home,
                      color: AppConfig.mainCyan,
                      size:
                          16), // Use any desired icon from flutter_icons package
                  SizedBox(width: 8), // Adjust the space between icon and text
                  Obx(
                    () => Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _takingOrderVendorController
                                      .choosedAddress.value ==
                                  ""
                              ? 'Pilih Alamat Pengiriman'
                              : _takingOrderVendorController
                                  .choosedAddress.value,
                          onChanged: (String? newValue) {
                            _takingOrderVendorController.choosedAddress.value =
                                newValue!;
                          },
                          items: <String>[
                            'Pemancar Lamtemen Timur',
                            'Pilih Alamat Pengiriman'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: TextView(
                                text: value,
                                textAlign: TextAlign.left,
                                fontSize: 14,
                                headings: 'H4',
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Container(
              width: 0.9 * Get.width,
              height: 10,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 0.45 * Get.width,
                  height: 0.1 * Get.height,
                  child: TextFormField(
                    // controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Catatan / Keterangan',
                      icon: Image.asset(
                        'assets/images/notes.png',
                        width: 45,
                        height: 45,
                        fit: BoxFit.fill,
                      ),
                    ),
                    maxLength: 150,
                    maxLines: null,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 14),
                    onChanged: (text) {
                      // Handle text changes here
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade500, width: 1),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      fixedSize: Size(0.27 * Get.width, 0.07 * Get.height),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextView(
                          text: 'Ganti Barang',
                          color: Colors.black,
                          headings: 'H4',
                          fontSize: 14,
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade700),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.manage_search,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            Container(
              width: 0.85 * Get.width,
              height: Get.height * 0.4,
              child: ListView.builder(
                itemCount: _takingOrderVendorController.cartDetailList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 0.05 * Get.width,
                        top: 5,
                        right: 0.05 * Get.width),
                    child: CheckoutList(
                        idx: (index + 1).toString(),
                        data:
                            _takingOrderVendorController.cartDetailList[index]),
                  );
                },
                physics: BouncingScrollPhysics(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 0.75 * Get.width,
              height: 0.06 * Get.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView(
                        text:
                            "${_takingOrderVendorController.cartDetailList.length}",
                        headings: 'H2',
                        fontSize: 15,
                        color: Colors.amber.shade900,
                      ),
                      TextView(
                        text: "Produk",
                        headings: 'H4',
                        fontSize: 13,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1.5,
                  height: 0.06 * Get.height,
                  color: Colors.grey.shade400,
                ),
                SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'assets/images/custorder.png',
                  width: 35,
                  height: 35,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView(
                        text: _takingOrderVendorController.formatNumber(
                            _takingOrderVendorController.countPriceTotal()),
                        headings: 'H2',
                        fontSize: 15,
                        color: Colors.amber.shade900,
                      ),
                      TextView(
                        text: "Perkiraan Pesanan",
                        headings: 'H4',
                        fontSize: 13,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 1.5,
                  height: 0.06 * Get.height,
                  color: Colors.grey.shade400,
                ),
                SizedBox(
                  width: 15,
                ),
                Image.asset(
                  'assets/images/komisi.png',
                  width: 35,
                  height: 35,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextView(
                        text: _takingOrderVendorController.formatNumber(2500),
                        headings: 'H2',
                        fontSize: 15,
                        color: Colors.amber.shade900,
                      ),
                      TextView(
                        text: "Perkiraan Komisi",
                        headings: 'H4',
                        fontSize: 13,
                      )
                    ],
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 0.02 * Get.height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevatedButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: AppConfig.mainCyan,
                      size: 21,
                    ),
                    text: "BATAL",
                    onTap: () {
                      Get.back();
                    },
                    width: 0.18 * Get.width,
                    height: 0.04 * Get.height,
                    radius: 4,
                    backgroundColor: Colors.white,
                    bordercolor: AppConfig.mainCyan,
                    elevation: 0,
                    textcolor: AppConfig.mainCyan,
                    headings: 'H2'),
                CustomElevatedButton(
                    icon: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 21,
                    ),
                    text: "SIMPAN",
                    onTap: () async {
                      Get.back();
                    },
                    width: 0.18 * Get.width,
                    height: 0.04 * Get.height,
                    radius: 4,
                    backgroundColor: AppConfig.mainCyan,
                    textcolor: Colors.white,
                    elevation: 2,
                    bordercolor: AppConfig.mainCyan,
                    headings: 'H2')
              ],
            )
          ],
        ),
      ),
    );
  }
}
