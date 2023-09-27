import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceListPage extends StatelessWidget {
  const PriceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: 0.02 * height,),
        Expanded(
            child: ListView.builder(
          itemBuilder: (c, i) {
            return Padding(
              padding: EdgeInsets.only(left: 0.05 * width,bottom: 0.025 * height),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: (){
                    print("pressed $i");
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 0.07 * width,
                        height: 0.07 * width,
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: TextView(
                            text: (i + 1).toString(),
                            color: Colors.white,
                            fontSize: 10.sp,
                            headings: 'H2',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.02 * width,
                      ),
                      Image.asset("assets/images/filepdf.png", height: 25.sp),
                      SizedBox(
                        width: 0.02 * width,
                      ),
                      AutoSizeText(
                        "01. Pricelist_Tangki_Promax.pdf",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 450
                                ? 9.sp
                                : 11.sp,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: 100,
          physics: const BouncingScrollPhysics(),
        )),
      ],
    );
  }
}
