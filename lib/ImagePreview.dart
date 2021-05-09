import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:flutter/material.dart';
import 'ChatPage.dart';

class ImageP extends StatefulWidget {
  @override
  _ImageState createState() => _ImageState();
}
class _ImageState extends State<ImageP> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InteractiveViewer(
        child:Image.file(tempMessage.file ),
        boundaryMargin: EdgeInsets.zero,
        maxScale: 6.0,
        minScale: 1.0,
      )
    );
  }
}
