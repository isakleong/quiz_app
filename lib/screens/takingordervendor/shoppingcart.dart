import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../common/app_config.dart';
import '../../controllers/taking_order_vendor_controller.dart';

class Shoppingcart extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  Shoppingcart({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() => Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Container(
            width: 0.9 * width,
            height: 0.18 * height,
            decoration: BoxDecoration(
                border: Border.all(color: AppConfig.mainCyan, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_mosaic_rounded,
                          color: AppConfig.mainCyan,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextView(
                          headings: 'H4',
                          fontSize: 14,
                          text: _takingOrderVendorController
                              .cnt.dropDownValue!.name,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          _takingOrderVendorController.addToCart(
                              _takingOrderVendorController
                                  .cnt.dropDownValue!.value
                                  .toString(),
                              _takingOrderVendorController
                                  .cnt.dropDownValue!.name
                                  .toString(),
                              10000.0,
                              int.parse(
                                  _takingOrderVendorController.qty1.value.text),
                              'unit');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.mainCyan,
                          elevation: 5,
                          fixedSize: Size(0.2 * width, 0.04 * height),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Icon(Icons.shopping_cart),
                              TextView(
                                text: "Tambah",
                                headings: 'H4',
                                fontSize: 14,
                                color: Colors.white,
                              )
                            ])),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.02 * width),
                child: Container(
                  width: 0.86 * width,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: Container(
                  width: 0.15 * width,
                  height: 0.025 * height,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: TextView(
                    text: "Unit",
                    headings: 'H3',
                    color: Colors.white,
                    fontSize: 14,
                  )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.05 * width, top: 10),
                child: Container(
                  width: 0.8 * width,
                  height: 0.05 * height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0.05 * width),
                          child: InkWell(
                            onTap: () {
                              _takingOrderVendorController.handleAddMinusBtn(
                                  _takingOrderVendorController.qty1.value, '-');
                            },
                            child: Icon(
                              FontAwesomeIcons.minus,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Container(
                          width: 0.1 * width,
                          height: 0.05 * height,
                          child: Center(
                            child: TextFormField(
                              controller:
                                  _takingOrderVendorController.qty1.value,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an integer';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0.05 * width),
                          child: InkWell(
                            onTap: () {
                              _takingOrderVendorController.handleAddMinusBtn(
                                  _takingOrderVendorController.qty1.value, '+');
                            },
                            child: Icon(
                              FontAwesomeIcons.plus,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ]),
                ),
              )
            ]),
          ),
        ));
  }
}
