import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../common/app_config.dart';

class ProductSearch extends StatelessWidget {
  const ProductSearch({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Container(
        width: 0.8 * width,
        height: 0.15 * height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 15, top: 15),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConfig.mainCyan,
                      ),
                    ),
                    Image.asset(
                      'assets/images/custorder.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(headings: "H2", text: "Penjualan", fontSize: 14),
                    SizedBox(
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
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Adek Abang"),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.02 * width),
            child: Container(
              width: 0.76 * width,
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.02 * width, top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppConfig.mainCyan,
                  size: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                TextView(
                  headings: 'H4',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  text: "Cari Produk",
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
