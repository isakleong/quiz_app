import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportpembayaran.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportpenjualan.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportretur.dart';

class ReportBody extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      physics: const BouncingScrollPhysics(),
      children: [ReportPenjualan(), ReportPembayaran(), ReportRetur()],
    ));
  }
}
