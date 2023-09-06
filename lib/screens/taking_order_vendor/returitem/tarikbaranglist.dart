import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/tarikbarangmodel.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../transaction/chipsitem.dart';

class TarikBarangList extends StatelessWidget {
  String idx;
  TarikBarangModel data;
  var onTapEdit;
  var onTapDelete;
  bool? hidebtn;
  Color? btndelete;
  Color? unit;
  TarikBarangList(
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
                            fontSize: 14.sp,
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
                            fontSize: 10.sp,
                            text: data.nmProduct,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              data.itemOrder.isNotEmpty
                                  ? ChipsItem(
                                      satuan:
                                          "${data.itemOrder[0].Qty} ${data.itemOrder[0].Satuan}",
                                      fontSize: 8.sp,
                                      color: unit ?? const Color(0XFF0098a6),
                                    )
                                  : Container(),
                              data.itemOrder.length > 1
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: ChipsItem(
                                        satuan:
                                            "${data.itemOrder[1].Qty} ${data.itemOrder[1].Satuan}",
                                        fontSize: 8.sp,
                                        color: unit ?? const Color(0XFF0098a6),
                                      ))
                                  : Container(),
                              data.itemOrder.length > 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: ChipsItem(
                                        satuan:
                                            "${data.itemOrder[2].Qty} ${data.itemOrder[2].Satuan}",
                                        fontSize: 8.sp,
                                        color: unit ?? const Color(0XFF0098a6),
                                      ))
                                  : Container()
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
                           if (Get.width > 450)
                            InkWell(
                              onTap: onTapEdit,
                              child: Container(
                                width: 28.sp,
                                height: 28.sp,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green.shade700),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 14.sp,
                                    )
                                  ],
                                ),
                              ),
                            )
                          else
                            InkWell(
                              onTap: onTapEdit,
                              child: Container(
                                width: 25.sp,
                                height: 25.sp,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green.shade700),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 12.sp,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (Get.width > 450)
                              InkWell(
                                onTap: onTapDelete,
                                child: Container(
                                  width: 28.sp,
                                  height: 28.sp,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade700),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 14.sp,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            else
                              InkWell(
                                onTap: onTapDelete,
                                child: Container(
                                  width: 25.sp,
                                  height: 25.sp,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade700),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 12.sp,
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
            data.alasan == ""
                ? Container()
                : Container(
                    width: 0.85 * Get.width,
                    height: 1,
                    color: Colors.grey.shade500,
                  ),
            data.alasan == ""
                ? Container()
                : const SizedBox(
                    height: 10,
                  ),
            data.alasan == ""
                ? Container()
                : Row(
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
                        text: "Alasan : ${data.alasan}",
                        fontSize: Get.width < 450 ? 10.sp : 14,
                      )
                    ],
                  ),
            data.alasan == ""
                ? Container()
                : const SizedBox(
                    height: 10,
                  ),
          ],
        ),
      ),
    );
  }
}
