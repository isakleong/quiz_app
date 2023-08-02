import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../widgets/backbuttonaction.dart';
import '../payment/piutangcard.dart';

class ReturMainPage extends StatelessWidget {
  const ReturMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/bg-homepage.svg',
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: BackButtonAction()),
                Padding(
                    padding: EdgeInsets.only(
                        left: 0.05 * Get.width, top: 0.02 * Get.height),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      child: SizedBox(
                        width: 0.9 * Get.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 15),
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
                                          'assets/images/custretur.png',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TextView(
                                            headings: "H2",
                                            text: "Retur",
                                            fontSize: 14),
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
                                height: 10,
                              ),
                            ]),
                      ),
                    )),
              ],
            )
          ],
        )));
  }
}
