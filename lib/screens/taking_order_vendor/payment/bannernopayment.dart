import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/textview.dart';

class BannerNoPayment extends StatelessWidget {
  const BannerNoPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Image.asset('assets/images/custpaymentempty.png',
                width: 0.45 * Get.width, fit: BoxFit.cover),
            SizedBox(
              width: 0.45 * Get.width,
              child: Column(
                children: [
                  TextView(
                    text: "Belum Ada Pembayaran",
                    headings: 'H2',
                    fontSize: 12.sp,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextView(
                    text:
                        "Anda dapat mulai menambahkan pembayaran untuk toko ini",
                    textAlign: TextAlign.center,
                    headings: 'H4',
                    fontSize: 10.sp,
                  )
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}
