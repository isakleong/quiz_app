import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/chipsitem.dart';

class TripleUnit extends StatelessWidget {
  TextEditingController ctrl;
  String satuan;
  var onTapMinus;
  var onTapPlus;
  TripleUnit(
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChipsItem(satuan: satuan),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 0.25 * width,
            height: 0.05 * height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0.025 * width),
                    child: InkWell(
                      onTap: onTapMinus,
                      child: Icon(
                        FontAwesomeIcons.minus,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.1 * width,
                    height: 0.05 * height,
                    child: Center(
                      child: TextFormField(
                        controller: ctrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
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
                    padding: EdgeInsets.only(right: 0.025 * width),
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
