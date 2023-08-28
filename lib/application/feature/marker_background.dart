import 'package:flutter/material.dart';

class MarkerBackground extends CustomPainter {
  Color selectColor;
  MarkerBackground(this.selectColor);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint = Paint()..color = selectColor;
    final Rect rect =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
    const double radius = 20;

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(radius)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
