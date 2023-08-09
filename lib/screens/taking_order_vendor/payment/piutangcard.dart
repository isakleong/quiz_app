import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';

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
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0XFF008996),
                      ),
                    ),
                    Image.asset(
                      'assets/images/custpayment.png',
                      width: 45,
                      height: 45,
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
                    const TextView(
                        headings: "H2", text: "Pembayaran", fontSize: 14),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Stack(
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
                        const Text("Adek Abang"),
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
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: const [
                    TextView(
                      text: "20,752,392",
                      headings: 'H3',
                      color: Color(0xFFf5511e),
                    ),
                    TextView(
                      text: "Total Piutang",
                      headings: 'H4',
                      fontSize: 14,
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
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: const [
                    TextView(
                      text: "20,752,392",
                      color: Color(0xFFf5511e),
                      headings: 'H3',
                    ),
                    TextView(
                      text: "Total Jatuh Tempo",
                      headings: 'H4',
                      fontSize: 14,
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
