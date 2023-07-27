import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../controllers/taking_order_vendor_controller.dart';

class SingleUnit extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  SingleUnit({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
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
                        controller: _takingOrderVendorController.qty1.value,
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
      ],
    );
  }
}
