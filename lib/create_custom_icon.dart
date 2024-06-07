import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomIcon(String price, bool isCluster, int clusterSize) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint fillPaint = Paint()..color = isCluster ? Colors.lightGreen : Colors.blue;
  final Paint strokePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  const double size = 150.0;
  const double radius = size / 2;
  const double pointerHeight = 15.0;
  const double rectWidth = 160.0;
  const double rectHeight = 60.0;
  const double outerRadius = radius + 10;
  double textX, textY;

  if (isCluster) {
    Offset center = const Offset(outerRadius + 5, outerRadius + 5);
    canvas.drawCircle(center, radius, fillPaint);

    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    );
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: clusterSize.toString(), style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textX = (2 * (outerRadius + 5) - textPainter.width) / 2;
    textY = (2 * (outerRadius + 5) - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textX, textY));
  } else {
    const double width = rectWidth;
    const double height = rectHeight;

    double rectTopLeftX = (size - rectWidth) / 2;
    double rectTopLeftY = (size - rectHeight) / 2;

    Path roundedRectPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(rectTopLeftX, rectTopLeftY, rectWidth, rectHeight),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ));

    canvas.drawShadow(roundedRectPath, Colors.black, 5.0, true);
    canvas.drawPath(roundedRectPath, fillPaint);
    canvas.drawPath(roundedRectPath, strokePaint);

    Path path = Path();
    double baseY = rectTopLeftY + rectHeight;
    path.moveTo(size / 2, baseY + pointerHeight);
    path.lineTo(size / 2 - pointerHeight / 2, baseY);
    path.lineTo(size / 2 + pointerHeight / 2, baseY);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    );
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: price, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textX = (size - textPainter.width) / 2;
    textY = rectTopLeftY + (rectHeight - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textX, textY));
  }

  final ui.Image image = await pictureRecorder.endRecording().toImage(
      (2 * (outerRadius + 5)).toInt(),
      (2 * (outerRadius + 5)).toInt());
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) {
    throw Exception('Failed to get byte data of the image');
  }

  return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
}