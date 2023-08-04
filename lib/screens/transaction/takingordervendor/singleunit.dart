import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/chipsitem.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChipsItem(satuan: satuan),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 0.8 * width, // Set the desired width
              child: TextFormField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero, // Remove the default padding
                  suffixIcon: IconButton(
                    onPressed: onTapPlus,
                    icon: Icon(
                      FontAwesomeIcons.plus,
                      size: 16, // Set the desired icon size
                      color: Colors.grey.shade500,
                    ),
                    padding:
                        EdgeInsets.zero, // Remove the padding around the icon
                  ),
                  prefixIcon: IconButton(
                    onPressed: onTapMinus,
                    icon: Icon(
                      FontAwesomeIcons.minus,
                      size: 16, // Set the desired icon size
                      color: Colors.grey.shade500,
                    ),
                    padding:
                        EdgeInsets.zero, // Remove the padding around the icon
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an integer';
                  }
                  return null;
                },
              ),
            ))
      ],
    );
  }
}
