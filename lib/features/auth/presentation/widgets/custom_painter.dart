import 'package:fmpglobalinc/core/config/theme.dart';
import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              AppTheme.gradientStart,
              AppTheme.gradientEnd,
            ],
          ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final path = Path();

    // Start from the top left
    path.moveTo(0, size.height * 0.45);

    // Create a smooth curve
    path.quadraticBezierTo(
      size.width * 0.5, // Control point x
      size.height * 0.35, // Control point y
      size.width, // End point x
      size.height * 0.45, // End point y
    );

    // Complete the shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
