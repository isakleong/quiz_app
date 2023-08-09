import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../widgets/textview.dart';
import '../takingordervendor/chipsitem.dart';

class ItemReportRetur extends StatelessWidget {
  const ItemReportRetur({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: SizedBox(
          width: 0.9 * Get.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 0.02 * Get.width, top: 2),
                        child: Container(
                          width: 0.075 * Get.width,
                          height: 0.075 * Get.width,
                          decoration: const BoxDecoration(
                            color: Color(0xFF512da7),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: TextView(
                              text: "1",
                              color: Colors.white,
                              fontSize: 18,
                              headings: 'H2',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          TextView(
                            text: "GR-00AC1A0103-202308070932-002",
                            headings: 'H4',
                            fontSize: 14,
                          ),
                          TextView(
                            text: "Tukar Warna",
                            fontSize: 13,
                          ),
                          // ChipsItem(
                          //   satuan: "notes test",
                          //   color: const Color(0xFFf5511e),
                          //   fontSize: 12,
                          // )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        TextView(
                          text: "07-08-2023",
                          fontSize: 14,
                        ),
                        TextView(
                          text: "09:32",
                          fontSize: 14,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Container(
                width: 0.85 * Get.width,
                color: Colors.grey.shade400,
                height: 3,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.05 * Get.width),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7, bottom: 7),
                      child: Container(
                        width: 5,
                        decoration:
                            const BoxDecoration(color: Color(0xFF9675ce)),
                      ),
                    ),
                    SizedBox(
                      width: 0.8 * Get.width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 7),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 0.025 * Get.width,
                                      ),
                                      Container(
                                        width: 0.07 * Get.width,
                                        height: 0.045 * Get.height,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: TextView(
                                            text: 1.toString(),
                                            headings: 'H3',
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 0.025 * Get.width,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const TextView(
                                            headings: 'H4',
                                            fontSize: 13,
                                            text:
                                                "AVIAN Cling Synthetic 11 - 17 LT",
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: ChipsItem(
                                                    satuan: "1 dos",
                                                    fontSize: 12,
                                                  )),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: ChipsItem(
                                                    satuan: "2 biji",
                                                    fontSize: 12,
                                                  )),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: ChipsItem(
                                                    satuan: "3 inner plas",
                                                    fontSize: 12,
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
                                ]),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 0.02 * Get.width,
                                top: 10,
                              ),
                              child: Container(
                                width: 0.85 * Get.width,
                                height: 2,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 0.025 * Get.width,
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.circleChevronRight,
                                        color: Color(0XFF6c4d43),
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const TextView(
                                        text:
                                            "AVIAN Cling Zinc Chromate 901 - 1 KG",
                                        fontSize: 13,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      for (var k = 0; k < 2; k++)
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: k == 1 ? 0 : 5),
                                            child: ChipsItem(
                                              satuan: k == 1
                                                  ? "1 dos"
                                                  : "2 inner plas",
                                              fontSize: 12,
                                              color: const Color(0xFFe44b1b),
                                            ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
        ));
  }
}
