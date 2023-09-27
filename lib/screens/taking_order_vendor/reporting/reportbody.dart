import 'package:flutter/material.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportpembayaran.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportpenjualan.dart';

class ReportBody extends StatelessWidget {
  const ReportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      physics: const BouncingScrollPhysics(),
      children: [ReportPenjualan(), ReportPembayaran(), 
      // ReportRetur()
      ],
    ));
  }
}
