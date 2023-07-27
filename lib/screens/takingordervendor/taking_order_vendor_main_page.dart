import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:sfa_tools/screens/takingordervendor/cartheader.dart';
import 'package:sfa_tools/screens/takingordervendor/cartlist.dart';
import 'package:sfa_tools/screens/takingordervendor/productsearch.dart';
import 'package:sfa_tools/screens/takingordervendor/shoppingcart.dart';
import 'package:sfa_tools/widgets/textview.dart';
import '../../common/app_config.dart';

class TakingOrderVendorMainPage extends StatelessWidget {
  const TakingOrderVendorMainPage({super.key});

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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: BackButtonAction()),
                Padding(
                    padding:
                        EdgeInsets.only(left: 0.05 * width, top: 0.02 * height),
                    child: ProductSearch()),
                Padding(
                    padding:
                        EdgeInsets.only(left: 0.05 * width, top: 0.02 * height),
                    child: Shoppingcart()),
                Padding(
                    padding:
                        EdgeInsets.only(left: 0.05 * width, top: 0.02 * height),
                    child: CartHeader()),
                Padding(
                    padding:
                        EdgeInsets.only(left: 0.05 * width, top: 0.02 * height),
                    child: CartList())
              ]),
            ],
          ),
        ));
  }
}
