import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';

import '../../../widgets/textview.dart';

class ProdukPenggantiHeader extends StatelessWidget {
  List list;
  var ontap;
  ProdukPenggantiHeader({super.key, required this.list, required this.ontap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 0.05 * width,
              ),
              Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFc4185c),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.layerGroup,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 0.02 * width,
              ),
              const TextView(
                text: "Barang Pengganti",
                headings: 'H3',
                fontSize: 18,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.05 * width),
            child: list.isEmpty
                ? ElevatedButton(
                    onPressed: ontap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.mainCyan,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 2, bottom: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.checkCircle,
                          size: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        TextView(
                          text: "Selesai",
                          headings: 'H4',
                          fontSize: 14,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                : Row(children: [
                    const TextView(text: "Sisa : "),
                    for (var j = 0; j < list.length; j++)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ChipsItem(
                          satuan: list[j],
                          color: const Color(0xFFc4185c),
                        ),
                      )
                  ]),
          )
        ],
      ),
    );
  }
}
