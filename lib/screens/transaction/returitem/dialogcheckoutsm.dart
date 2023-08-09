import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/returitem/checkoutlistgb.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class DialogCheckoutSm extends StatelessWidget {
  DialogCheckoutSm({super.key});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.9,
      height: 0.85 * Get.height,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.02 * Get.height),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
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
                      space: 5,
                      backgroundColor: Colors.white,
                      bordercolor: AppConfig.mainCyan,
                      elevation: 0,
                      textcolor: AppConfig.mainCyan,
                      headings: 'H2'),
                  CustomElevatedButton(
                      icon: const Icon(
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
                      space: 5,
                      backgroundColor: AppConfig.mainCyan,
                      textcolor: Colors.white,
                      elevation: 2,
                      bordercolor: AppConfig.mainCyan,
                      headings: 'H2')
                ],
              ),
            ),
          ),
          Column(children: [
            SizedBox(
              height: 0.02 * Get.height,
            ),
            const TextView(
              text: "Servis Mebel - Aceh Indah",
              headings: 'H3',
              fontSize: 16,
            ),
            SizedBox(
              height: 0.01 * Get.height,
            ),
            Container(
              width: Get.width,
              height: 10,
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: 0.01 * Get.height,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 0.05 * Get.width, right: 0.05 * Get.width),
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
                style: const TextStyle(fontSize: 14),
                onChanged: (text) {
                  // Handle text changes here
                },
              ),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0.08 * Get.height),
                    child: ListView.builder(
                      itemBuilder: (c, i) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 0.05 * Get.width, right: 0.05 * Get.width),
                          child: CheckoutListGb(
                            data:
                                _takingOrderVendorController.listServisMebel[i],
                            idx: (i + 1).toString(),
                          ),
                        );
                      },
                      itemCount:
                          _takingOrderVendorController.listServisMebel.length,
                      physics: const BouncingScrollPhysics(),
                    )))
          ]),
        ],
      ),
    );
  }
}
