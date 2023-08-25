import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleUnit extends StatelessWidget {
  TextEditingController ctrl;
  String satuan;
  var onTapMinus;
  var onTapPlus;
  Color? colorChips;
  SingleUnit(
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
          fontSize: 10.sp,
          color: colorChips ?? const Color(0XFF0098a6),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 0.83 * width, // Set the desired width
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onTapMinus,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.minus,
                        size: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: ctrl,
                      style: TextStyle(fontSize: 12.sp),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: InputBorder.none, // Remove the border
                        isDense: true, // Reduce the vertical padding
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
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onTapPlus,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.plus,
                        size: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
