import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../widgets/textview.dart';

class SearchReport extends StatelessWidget {
  String value;
  String nmToko;
  var onChanged;
  SearchReport({super.key, required this.value, required this.onChanged, required this.nmToko});

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
              children: [
                width < 450 ?
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
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Image.asset(
                        'assets/images/custreport.png',
                        width: 35.sp,
                        height: 35.sp,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ) : Stack(
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
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Image.asset(
                        'assets/images/custreport.png',
                        width: 45,
                        height: 45,
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
                        headings: "H2", text: "Laporan", fontSize: width < 450 ? 10.sp : 14),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        width < 450 ?
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
                         Text(nmToko, style: TextStyle(fontSize: width < 450 ? 10.sp :14)),
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
            padding: EdgeInsets.only(left: 0.02 * width),
            child: Container(
              width: 0.86 * width,
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 0.05 * width,
                right: 0.05 * width,
                top: 0.01 * height,
                bottom: 0.01 * height),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.grey.shade500)),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: value,
                    onChanged: onChanged,
                    items: <String>[
                      'Semua Transaksi',
                      'Transaksi Penjualan',
                      'Transaksi Pembayaran',
                      // 'Transaksi Retur',
                      // 'Transaksi TTH',
                      // 'Transaksi Survey',
                      // 'Transaksi Keluhan'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.filter_alt_rounded,
                              size: width < 450 ? 14.sp : 18,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextView(
                              text: value,
                              textAlign: TextAlign.left,
                              fontSize: width < 450 ? 10.sp : 13,
                              headings: 'H4',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
