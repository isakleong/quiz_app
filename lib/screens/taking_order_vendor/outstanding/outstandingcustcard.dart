import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sfa_tools/widgets/closeoverlayaction.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../widgets/textview.dart';

class OutstandingCustCard extends StatelessWidget {
  String nmtoko;
  var ontap;
  OutstandingCustCard({super.key,required this.nmtoko, required this.ontap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50.sp,
                          height: 50.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppConfig.mainCyan,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left :5.0),
                          child: Image.asset(
                            'assets/images/outstanding.png',
                            width: 35.sp,
                            height: 35.sp,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                            headings: "H2",
                            text: "Outstanding",
                            fontSize: 10.sp),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 14.sp,
                                  height: 14.sp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppConfig.mainCyan,
                                  ),
                                ),
                                Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 10.sp,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            TextView(
                              text: nmtoko,
                              fontSize: 10.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CloseOverlayAction(ontap: ontap),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0.025 * height,
          ),
        ]),
      ),
    );
  }
}
