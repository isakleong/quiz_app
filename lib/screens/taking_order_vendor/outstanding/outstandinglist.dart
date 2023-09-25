import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/models/outstandingdata.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class OutstandingList extends StatelessWidget {
  OutstandingData data;
  OutstandingList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Colors.white,
      child: SizedBox(
          width: 0.9 * width,
          child: Column(
            children: [
              Container(
                width: 0.9 * width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: AppConfig.mainCyan),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    SizedBox(
                      width: 0.015 * width,
                    ),
                    Image.asset(
                      'assets/images/outstanding.png',
                      width: 30.sp,
                      height: 30.sp,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      width: 0.015 * width,
                    ),
                    TextView(
                      text: data.salesOrder!.code,
                      color: Colors.white,
                      headings: 'H3',
                      fontSize: 11.sp,
                    )
                  ]),
                ),
              ),
              for (var n = 0; n < data.details!.length; n++)
                Padding(
                  padding: EdgeInsets.only(left: 0.02 * width, top: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextView(
                            fontSize: 9.sp,
                            headings: 'H4',
                            text: "${n + 1}. ${data.details![n].itemName}"),
                        Row(
                          children: [
                            TextView(
                              fontSize: 10.sp,
                              headings: 'H4',
                              text:
                                  "${data.details![n].qty} ${data.details![n].uom}",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(FontAwesomeIcons.minusCircle,
                                size: 14.sp, color: Colors.red),
                            SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              )
            ],
          )),
    );
  }
}
