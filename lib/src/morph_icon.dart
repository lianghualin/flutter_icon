import 'dart:ui';

import 'package:flutter/material.dart';

class MorphSidebarTabBarIcon extends StatefulWidget {
  const MorphSidebarTabBarIcon({
    super.key,
    this.size = 24.0,
    this.color = Colors.white,
    this.strokeWidth,
    this.onToggled,
  });

  final double size;
  final Color color;
  final double? strokeWidth;
  final ValueChanged<bool>? onToggled;

  @override
  State<MorphSidebarTabBarIcon> createState() =>
      _MorphSidebarTabBarIconState();
}

class _MorphSidebarTabBarIconState extends State<MorphSidebarTabBarIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  bool _isSidebar = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isSidebar) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isSidebar = !_isSidebar;
    widget.onToggled?.call(_isSidebar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            size: Size.square(widget.size),
            painter: _MorphIconPainter(
              progress: _progress.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth ?? (widget.size / 16).clamp(1.0, 3.0),
            ),
          );
        },
      ),
    );
  }
}

class _MorphIconPainter extends CustomPainter {
  _MorphIconPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final radius = w * 0.18;

    // 1. Outer rounded rectangle — constant frame
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(radius),
    );
    canvas.drawRRect(outerRect, paint);

    // Inset to keep divider/details inside the rounded rect
    final inset = strokeWidth / 2;

    // 2. Divider line — morphs between:
    //   Sidebar (progress=0): vertical line at x=30%, full height
    //   Tab bar (progress=1): short horizontal dash near top center (~35%-65% width, y≈20%)
    final divX1 = lerpDouble(w * 0.30, w * 0.35, progress)!;
    final divY1 = lerpDouble(inset, h * 0.20, progress)!;
    final divX2 = lerpDouble(w * 0.30, w * 0.65, progress)!;
    final divY2 = lerpDouble(h - inset, h * 0.20, progress)!;

    canvas.drawLine(Offset(divX1, divY1), Offset(divX2, divY2), paint);

    // 3. Interior detail lines (3 small horizontal lines in sidebar panel)
    //   Sidebar state: visible horizontal lines stacked in left panel
    //   Tab bar state: collapsed to zero length and faded out
    const detailCount = 3;
    final detailOpacity = (1.0 - progress).clamp(0.0, 1.0);
    if (detailOpacity > 0.0) {
      final detailPaint = Paint()
        ..color = color.withValues(alpha: detailOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < detailCount; i++) {
        final t = (i + 1) / (detailCount + 1);

        // Sidebar positions (horizontal lines in left panel)
        final sX1 = w * 0.08;
        final sX2 = w * 0.22;
        final sY = h * (0.25 + t * 0.50);

        // Tab bar positions: collapse to center point near top
        final centerX = w * 0.50;
        final centerY = h * 0.20;

        final x1 = lerpDouble(sX1, centerX, progress)!;
        final y1 = lerpDouble(sY, centerY, progress)!;
        final x2 = lerpDouble(sX2, centerX, progress)!;
        final y2 = lerpDouble(sY, centerY, progress)!;

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), detailPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_MorphIconPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
