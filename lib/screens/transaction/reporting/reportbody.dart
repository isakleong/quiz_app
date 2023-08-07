import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportpembayaran.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportpenjualan.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportretur.dart';
import 'package:sfa_tools/screens/transaction/reporting/reportheader.dart';
import 'package:sfa_tools/screens/transaction/reporting/reportpembayaran.dart';
import 'package:sfa_tools/screens/transaction/reporting/reportpenjualan.dart';
import 'package:sfa_tools/screens/transaction/reporting/reportretur.dart';

import '../../../widgets/textview.dart';
import '../takingordervendor/chipsitem.dart';

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
