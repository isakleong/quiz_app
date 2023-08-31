import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sfa_tools/widgets/textview.dart';

class ViewPDFScreen extends StatefulWidget {
  final String path;
  const ViewPDFScreen(this.path, {Key? key}) : super(key: key);

  @override
  _ViewPDFScreenState createState() => _ViewPDFScreenState();
}

class _ViewPDFScreenState extends State<ViewPDFScreen> {
  int pageindex = 0, pagecount = 0;
  late PdfController controller;

  @override
  void initState() {
    controller = PdfController(document: PdfDocument.openFile(widget.path));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: PdfView(
                controller: controller,
                onPageChanged: (page) {
                  setState(() {
                    pageindex = page;
                  });
                },
                onDocumentLoaded: (document) {
                  setState(() {
                    pageindex = 1;
                    pagecount = document.pagesCount;
                  });
                },
              ),
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextView(text: pageindex.toString(), fontSize : 14),
                  TextView(text: ' / ', fontSize : 14),
                  TextView(text: pagecount.toString(), fontSize : 14)
                ],
              ),
            ),
            /*
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Material(
                  elevation: 0,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => {Get.back()},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade900.withOpacity(0.3),
                      ),
                      child: const Icon(MdiIcons.close, color: Colors.white, size: 36),
                    ),
                  ),
                ),
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}
