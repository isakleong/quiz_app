import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../common/app_config.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF48d4d1),
                    Color(0xFF378a8a),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/cart.png',
                    width: 40,
                    height: 40,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  text: "Keranjang",
                  headings: 'H3',
                  fontSize: 16,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: 0.18 * width,
                      height: 28,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextView(
                          text: "1 Produk",
                          headings: 'H3',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 0.25 * width,
                      height: 28,
                      decoration: BoxDecoration(
                          color: Color(0xFF8B4513),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextView(
                          text: "Total : 1,229,200",
                          headings: 'H3',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: 0.05 * width),
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.mainCyan,
                elevation: 5,
                fixedSize: Size(0.25 * width, 0.045 * height),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.all(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextView(
                    text: "LANJUTKAN",
                    color: Colors.white,
                    headings: 'H2',
                    fontSize: 14,
                  ),
                  TextView(
                    text: ">>",
                    color: Colors.white,
                    headings: 'H2',
                    fontSize: 14,
                  )
                ],
              )),
        )
      ],
    );
  }
}
