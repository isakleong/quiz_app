import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/tukarwarnamodel.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../takingordervendor/chipsitem.dart';

class TukarWarnaList extends StatelessWidget {
  String idx;
  TukarWarnaModel data;
  var onTapEdit;
  var onTapDelete;
  bool? hidebtn;
  Color? btndelete;
  Color? unit;
  TukarWarnaList(
      {super.key,
      required this.idx,
      required this.data,
      this.onTapEdit,
      this.onTapDelete,
      this.hidebtn,
      this.btndelete,
      this.unit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * Get.width,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 0.025 * Get.width,
                      ),
                      Container(
                        width: 0.0725 * Get.width,
                        height: 0.0725 * Get.width,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextView(
                            text: idx,
                            headings: 'H2',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.025 * Get.width,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            headings: 'H4',
                            fontSize: 14,
                            text: data.nmProduct,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var j = 0;
                                  j < data.listqtyheader.length;
                                  j++)
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: j == 0 ? 0.0 : 5),
                                    child: ChipsItem(
                                      satuan:
                                          "${data.listqtyheader[j].Qty} ${data.listqtyheader[j].Satuan}",
                                      fontSize: 12,
                                      color: unit ?? const Color(0XFF0098a6),
                                    ))

                              // SizedBox(
                              //   width: 0.1 * width,
                              // ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  (hidebtn != null && hidebtn == true)
                      ? Container()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: onTapEdit,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green.shade700),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: const [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: onTapDelete,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: btndelete ?? Colors.red.shade700),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: const [
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                ]),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 0.85 * Get.width,
              height: 1,
              color: Colors.grey.shade500,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 0.9 * Get.width,
              child: ListView.builder(
                  itemCount: data.listitemdetail.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: ((context, innerindex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 0.025 * Get.width,
                              ),
                              const Icon(
                                FontAwesomeIcons.circleChevronRight,
                                color: Colors.brown,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextView(
                                text:
                                    data.listitemdetail[innerindex].nmProduct,
                                fontSize: 14,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (var k = 0;
                                  k <
                                      data.listitemdetail[innerindex].itemOrder
                                          .length;
                                  k++)
                                Padding(
                                    padding: EdgeInsets.only(
                                        right: k ==
                                                (data.listitemdetail[innerindex]
                                                        .itemOrder.length -
                                                    1)
                                            ? 15
                                            : 5),
                                    child: ChipsItem(
                                      satuan:
                                          "${data.listitemdetail[innerindex].itemOrder[k].Qty} ${data.listitemdetail[innerindex].itemOrder[k].Satuan}",
                                      fontSize: 12,
                                      color: const Color(0xFFe44b1b),
                                    ))
                            ],
                          )
                        ],
                      ),
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}
