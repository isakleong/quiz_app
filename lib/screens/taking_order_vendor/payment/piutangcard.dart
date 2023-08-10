import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/textview.dart';

class PiutangCard extends StatelessWidget {
  const PiutangCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * Get.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50.sp,
                      height: 50.sp,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0XFF008996),
                      ),
                    ),
                    Image.asset(
                      'assets/images/custpayment.png',
                      width: 35.sp,
                      height: 35.sp,
                      fit: BoxFit.cover,
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
                        headings: "H2", text: "Pembayaran", fontSize: 10.sp),
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
                          text: "Adek Abang",
                          fontSize: 10.sp,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.02 * Get.width),
            child: Container(
              width: 0.86 * Get.width,
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 0.05 * Get.width, right: 0.05 * Get.width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/images/paymenttotal.png',
                  width: 35.sp,
                  height: 35.sp,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    TextView(
                      text: "20,752,392",
                      headings: 'H3',
                      fontSize: 11.sp,
                      color: Color(0xFFf5511e),
                    ),
                    TextView(
                      text: "Total Piutang",
                      headings: 'H4',
                      fontSize: 10.sp,
                    )
                  ],
                ),
                Container(
                  width: 1,
                  height: 0.04 * Get.height,
                  color: Colors.grey.shade400,
                ),
                Image.asset(
                  'assets/images/datetime.png',
                  width: 35.sp,
                  height: 35.sp,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    TextView(
                      text: "20,752,392",
                      color: Color(0xFFf5511e),
                      headings: 'H3',
                      fontSize: 11.sp,
                    ),
                    TextView(
                      text: "Total Jatuh Tempo",
                      headings: 'H4',
                      fontSize: 10.sp,
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
