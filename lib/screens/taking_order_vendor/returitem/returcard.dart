import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../widgets/textview.dart';

class ReturCard extends StatelessWidget {
  String nmToko;
  ReturCard({super.key,required this.nmToko});

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
                Get.width < 450 ?
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
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Image.asset(
                        'assets/images/custretur.png',
                        width: 35.sp,
                        height: 35.sp,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ): Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0XFF008996),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Image.asset(
                          'assets/images/custretur.png',
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ) ,
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                        headings: "H2", text: "Retur", fontSize: Get.width < 450 ? 10.sp : 14),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Get.width < 450 ?
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 16.sp,
                              height: 16.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppConfig.mainCyan,
                              ),
                            ),
                             Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 12.sp,
                            )
                          ],
                        ) : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppConfig.mainCyan,
                              ),
                            ),
                            const Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                         Text(nmToko, style: TextStyle(fontSize: Get.width < 450 ? 10.sp :14)),
                      ],
                    ),
                  ],
                )
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
