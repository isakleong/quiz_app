import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/cartdetail.dart';
import '../../../widgets/textview.dart';
import '../transaction/chipsitem.dart';

class ItemListPenjualan extends StatelessWidget {
  String idx;
  CartDetail data;
  ItemListPenjualan({super.key, required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: 0.05 * width),
      child: Row(
        children: [
          Container(
            width: 5,height: 0.05 * height,
            decoration: const BoxDecoration(color: Color(0xFFfe8a66)),
          ),
          SizedBox(
            width: 0.8 *  width,
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
                              width: 0.02 * width,
                            ),
                            Container(
                              width: 0.08 * width,
                              height: 0.05 * height,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: TextView(
                                  text: idx,
                                  headings: 'H3',
                                  fontSize: width < 450 ? 12.sp : 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0.02 * width,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(width < 450)
                                TextView(
                                  headings: 'H4',
                                  fontSize: data.nmProduct.length  > 30 ? 8.sp : 10.sp ,
                                  text: data.nmProduct,
                                )
                                else
                                TextView(
                                  headings: 'H4',
                                  fontSize: data.nmProduct.length > 50 ? 9.5.sp : 10.sp ,
                                  text: data.nmProduct,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for(var j = 0 ; j < data.itemOrder.length; j++)
                                    Padding(
                                      padding: EdgeInsets.only(left: j == 0 ? 0.0 : 5),
                                        child: ChipsItem(
                                          satuan: "${data.itemOrder[j].Qty} ${data.itemOrder[j].Satuan}",
                                            fontSize: width < 450 ? 8.sp : 12,
                                    )),
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
