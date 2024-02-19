import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/coupon_mab_controller.dart';
import 'package:sfa_tools/models/couponmab.dart';
import 'package:sfa_tools/screens/coupon_mab/approval_item_detail.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/dialogconfirm.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/textview.dart';

class ApprovalItem extends StatelessWidget {
  // const ApprovalItem({super.key});

  final List<CouponMABData> listDataMAB;
  final int index;

  ApprovalItem({super.key, required this.index, required this.listDataMAB});
  final CouponMABController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        elevation: 1.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300)),
            child: Stack(
              children: [
                Positioned(
                  top: -15,
                  left: -45,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.withOpacity(0.5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Center(
                        child: TextView(
                          headings: "H3",
                          text: (index + 1).toString(),
                          fontSize: 16,
                          color: Colors.black,
                          isAutoSize: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      TextView(
                          headings: "H3",
                          text: listDataMAB[index].id,
                          fontSize: 16,
                          color: Colors.black,
                          isAutoSize: true,
                          textAlign: TextAlign.start,
                          maxLines: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextView(
                              headings: "H3",
                              text: listDataMAB[index].jenis,
                              fontSize: 14,
                              color: Colors.black),
                          TextView(
                              headings: "H3",
                              text: DateFormat("dd-MM-yyyy (HH:mm)").format(
                                  DateTime.parse(
                                      listDataMAB[index].createdOn!)),
                              fontSize: 14,
                              color: Colors.black),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(
                          color: Colors.grey.shade300,
                          thickness: 3,
                          height: 3,
                          indent: 0,
                          endIndent: 10),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const FaIcon(FontAwesomeIcons.userPen,
                                        color: Colors.deepOrangeAccent,
                                        size: 16),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                        width: 50,
                                        child: TextView(
                                            headings: "H3",
                                            text: "Sales",
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            maxLines: 1,
                                            isAutoSize: true,
                                            textAlign: TextAlign.start)),
                                    Expanded(
                                      child: TextView(
                                          headings: "H3",
                                          text:
                                              ":  ${listDataMAB[index].createdBy} (${listDataMAB[index].salesName})",
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          maxLines: 1,
                                          isAutoSize: true,
                                          textAlign: TextAlign.start),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const FaIcon(FontAwesomeIcons.store,
                                        color: Colors.deepOrangeAccent,
                                        size: 16),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                        width: 50,
                                        child: TextView(
                                            headings: "H3",
                                            text: "Toko",
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            maxLines: 1,
                                            isAutoSize: true,
                                            textAlign: TextAlign.start)),
                                    Expanded(
                                      child: TextView(
                                          headings: "H3",
                                          text:
                                              ":  ${listDataMAB[index].custID} (${listDataMAB[index].custName})",
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          maxLines: 1,
                                          isAutoSize: true,
                                          textAlign: TextAlign.start),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const FaIcon(FontAwesomeIcons.idCardClip,
                                        color: Colors.deepOrangeAccent,
                                        size: 16),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                        width: 50,
                                        child: TextView(
                                            headings: "H3",
                                            text: "Nama",
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            maxLines: 1,
                                            isAutoSize: true,
                                            textAlign: TextAlign.start)),
                                    Expanded(
                                        child: listDataMAB[index]
                                                    .namaBelakang !=
                                                "-"
                                            ? TextView(
                                                headings: "H3",
                                                text:
                                                    ":  ${listDataMAB[index].namaDepan} ${listDataMAB[index].namaBelakang}",
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                maxLines: 1,
                                                isAutoSize: true,
                                                textAlign: TextAlign.start)
                                            : TextView(
                                                headings: "H3",
                                                text:
                                                    ":  ${listDataMAB[index].namaDepan}",
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                maxLines: 1,
                                                isAutoSize: true,
                                                textAlign: TextAlign.start)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const FaIcon(FontAwesomeIcons.phone,
                                        color: Colors.deepOrangeAccent,
                                        size: 16),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                        width: 50,
                                        child: TextView(
                                            headings: "H3",
                                            text: "No HP",
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            maxLines: 1,
                                            isAutoSize: true,
                                            textAlign: TextAlign.start)),
                                    Expanded(
                                      child: TextView(
                                          headings: "H3",
                                          text: ":  ${listDataMAB[index].noHp}",
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          maxLines: 1,
                                          isAutoSize: true,
                                          textAlign: TextAlign.start),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(
                          color: Colors.grey.shade300,
                          thickness: 3,
                          height: 3,
                          indent: 0,
                          endIndent: 10),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade700),
                              onPressed: () async {
                                Get.defaultDialog(
                                    radius: 6,
                                    barrierDismissible: false,
                                    title: "",
                                    titlePadding: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 0),
                                    content: ApprovalItemDetail(index: index, listDataMAB: controller.filterlistDataMAB));

                                // Get.dialog(
                                //   Dialog(
                                //   backgroundColor: Colors.white,
                                //   shape: const RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.all(Radius.circular(10))),
                                //   child: DialogConfirm(
                                //     message: "msg",
                                //     title: "title",
                                //     onTap: (){},
                                //   ))
                                // );
                              },
                              child: SizedBox(
                                width: 140,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    TextView(
                                        headings: "H2",
                                        text: "Detail",
                                        fontSize: 14,
                                        color: Colors.white,
                                        isCapslock: true),
                                    SizedBox(width: 8),
                                    FaIcon(FontAwesomeIcons.eye,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
