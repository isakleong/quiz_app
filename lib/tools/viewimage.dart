import 'dart:io';

import 'package:flutter/material.dart';

class ViewImageScreen extends StatefulWidget {
  final String path;
  const ViewImageScreen(this.path, {Key? key}) : super(key: key);

  @override
  _ViewImageScreenState createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                maxScale: 6,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.file(File(widget.path), width: MediaQuery.of(context).size.width, fit: BoxFit.contain),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
