import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/takingordervendor/chipsitem.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../controllers/taking_order_vendor_controller.dart';

class SingleUnit extends StatelessWidget {
  TextEditingController ctrl;
  String satuan;
  var onTapMinus;
  var onTapPlus;
  SingleUnit(
      {super.key,
      required this.ctrl,
      required this.satuan,
      required this.onTapMinus,
      required this.onTapPlus});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ChipsItem(satuan: satuan),
        Padding(
          padding: EdgeInsets.only(top: 10),
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
                      onTap: onTapMinus,
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
                        controller: ctrl,
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
                      onTap: onTapPlus,
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
