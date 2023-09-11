import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportbody.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/searchreport.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:sfa_tools/widgets/textview.dart';

class ReportMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Obx(
        () => Stack(children: [
          SvgPicture.asset(
            'assets/images/bg-homepage.svg',
            fit: BoxFit.cover,
          ),
          _takingOrderVendorController.allReportlength.value == 0
              ? Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/notfound.json',
                        width: width * 0.35),
                    const TextView(
                      text: "Tidak Ada Laporan",
                      headings: 'H4',
                      fontSize: 20,
                    )
                  ],
                ))
              : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: BackButtonAction()),
              Padding(
                  padding: EdgeInsets.only(
                      left: 0.05 * width, top: 0.01 * height),
                  child: SearchReport(
                    nmToko: "${_takingOrderVendorController.nmtoko.value}",
                    value:
                        _takingOrderVendorController.choosedReport.value == ""
                            ? 'Semua Transaksi'
                            : _takingOrderVendorController.choosedReport.value,
                    onChanged: (String? newValue) async {
                      _takingOrderVendorController.choosedReport.value =
                          newValue!;
                      await _takingOrderVendorController.filteReport();
                    },
                  )),
              ReportBody(),
            ],
          )
        ]),
      )),
    );
  }
}
