import 'package:flutter/material.dart';

/// Static painter for rendering the sidebar or tab bar icon without animation.
class StaticIconPainter extends CustomPainter {
  StaticIconPainter._({required this.color, required this.isSidebar});

  factory StaticIconPainter.sidebar({required Color color}) =>
      StaticIconPainter._(color: color, isSidebar: true);

  factory StaticIconPainter.tabBar({required Color color}) =>
      StaticIconPainter._(color: color, isSidebar: false);

  final Color color;
  final bool isSidebar;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sw = (w / 16).clamp(1.0, 3.0);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    final radius = w * 0.18;
    final inset = sw / 2;

    // Outer rounded rectangle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, w, h),
        Radius.circular(radius),
      ),
      paint,
    );

    if (isSidebar) {
      // Vertical divider at x=30%, full height
      canvas.drawLine(
        Offset(w * 0.30, inset),
        Offset(w * 0.30, h - inset),
        paint,
      );
      // Horizontal menu lines in left panel
      for (int i = 0; i < 3; i++) {
        final t = (i + 1) / 4;
        final y = h * (0.25 + t * 0.50);
        canvas.drawLine(Offset(w * 0.08, y), Offset(w * 0.22, y), paint);
      }
    } else {
      // Short horizontal dash near top center
      canvas.drawLine(
        Offset(w * 0.35, h * 0.20),
        Offset(w * 0.65, h * 0.20),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StaticIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isSidebar != isSidebar;
  }
}
