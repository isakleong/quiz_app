import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';

class TripleUnit extends StatelessWidget {
  TextEditingController ctrl;
  String satuan;
  var onTapMinus;
  var onTapPlus;
  Color? colorChips;
  TripleUnit(
      {super.key,
      required this.ctrl,
      required this.satuan,
      required this.onTapMinus,
      required this.onTapPlus,
      this.colorChips});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChipsItem(
          satuan: satuan,
          color: colorChips ?? const Color(0XFF0098a6),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 0.25 * width, // Set the desired width
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
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
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
