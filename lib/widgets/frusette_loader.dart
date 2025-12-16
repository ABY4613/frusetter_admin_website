import 'dart:math' as math;
import 'package:flutter/material.dart';

class FrusetteLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const FrusetteLoader({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  State<FrusetteLoader> createState() => _FrusetteLoaderState();
}

class _FrusetteLoaderState extends State<FrusetteLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.color ?? theme.primaryColor;
    final secondaryColor = const Color(0xFF6A11CB); // Accent purple
    final tertiaryColor = const Color(0xFF2575FC); // Accent blue

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _LoaderPainter(
              animation: _controller.value,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              tertiaryColor: tertiaryColor,
            ),
            child: Center(
              child: Icon(
                Icons.eco,
                color: primaryColor.withOpacity(
                    0.8 + (0.2 * math.sin(_controller.value * 2 * math.pi))),
                size: widget.size * 0.3,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  _LoaderPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.08;

    // Paint for the rotating arcs
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Ring 1 - Outer Slow
    paint.color = primaryColor;
    final angle1 = 2 * math.pi * animation;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      angle1,
      math.pi * 0.6,
      false,
      paint,
    );

    // Ring 2 - Inner Fast Reverse
    paint.color = secondaryColor;
    paint.strokeWidth = strokeWidth * 0.8;
    final angle2 = -2 * math.pi * (animation * 1.5);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth * 3),
      angle2,
      math.pi * 0.8,
      false,
      paint,
    );

    // Ring 3 - Middle Offset
    paint.color = tertiaryColor.withOpacity(0.6);
    paint.strokeWidth = strokeWidth * 0.6;
    final angle3 = 2 * math.pi * (animation * 0.8 + 0.5);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth * 2),
      angle3,
      math.pi * 0.4,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoaderPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
