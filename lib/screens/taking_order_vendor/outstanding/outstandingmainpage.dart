import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/outstanding/outstandingcustcard.dart';
import 'package:sfa_tools/widgets/closeoverlayaction.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/backbuttonaction.dart';
import '../../../widgets/textview.dart';

class OutStandingMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  OutStandingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                Padding(
                    padding: EdgeInsets.only(
                      left: 0.05 * width,
                      top: 0.05 * height,
                    ),
                    child: OutstandingCustCard(
                        nmtoko: _takingOrderVendorController.nmtoko.value,
                        ontap: () {
                          _takingOrderVendorController
                              .overlayactivepenjualan.value = "penjualan";
                        })),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 0.055 * width),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.white,
                      child: SizedBox(
                          width: 0.9 * width,
                          child: Column(
                            children: [
                              Container(
                                width: 0.9 * width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    color: AppConfig.mainCyan),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 0.015 * width,
                                    ),
                                    Image.asset(
                                      'assets/images/outstanding.png',
                                      width: 30.sp,
                                      height: 30.sp,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      width: 0.015 * width,
                                    ),
                                    TextView(
                                      text: "SG-13A-2308-05115",
                                      color: Colors.white,
                                      headings: 'H3',
                                      fontSize: 11.sp,
                                    )
                                  ]),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.02 * width, top: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextView(
                                      fontSize: 10.sp,headings: 'H4',
                                      text:
                                          "1. Jerapah PROMAX 2000 L Graniti Brown Dengan Tool Kit",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          )),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
