import 'package:flutter/material.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../tools/utils.dart';
import '../../../widgets/textview.dart';

class ItemListPembayaran extends StatelessWidget {
  String idx;
  PaymentData data;
  // final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ItemListPembayaran({super.key, required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: 0.05 * width),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 0.04 * height,
            decoration: const BoxDecoration(color: Color(0xFF4fc2f8)),
          ),
          SizedBox(
            width: 0.7 * width,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 7),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 0.025 * width,
                            ),
                            Container(
                              width: 0.07 * width,
                              height: 0.04 * height,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: TextView(
                                  text:  idx,
                                  headings: 'H3',
                                  fontSize: width < 450 ? 12.sp : 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0.025 * width,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(
                                  headings: 'H4',
                                  fontSize: width < 450 ? 10.sp : 13,
                                  text: data.jenis == "cn"
                                      ? "Potongan CN"
                                      : data.jenis == "cek"
                                          ? "Cek / Giro / Slip - ${data.tipe} [${data.nomor}]"
                                          :  (data.jenis == "Transfer" ? data.jenis : "${data.jenis} - ${data.tipe}"),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextView(
                                      text:
                                          "Rp ${Utils().formatNumber(data.value.toInt())}",
                                      fontSize: width < 450 ? 10.sp : 13,
                                    ),
                                    SizedBox(
                                      width: 0.01 * width,
                                    ),
                                    data.jatuhtempo == ""
                                        ? Container()
                                        : ChipsItem(
                                            satuan:
                                                "Jatuh Tempo : ${data.jatuhtempo}",
                                            fontSize: width < 450 ? 8.sp : 12,
                                          )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
