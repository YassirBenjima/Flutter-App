import 'package:flutter/material.dart';

class CustomSpinner extends StatefulWidget {
  final double size;
  final Color? color;
  final Duration duration;

  const CustomSpinner({
    super.key,
    this.size = 30.0,
    this.color,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: SpinnerPainter(
              progress: _animation.value,
              color: widget.color ?? Colors.grey[600]!,
            ),
          );
        },
      ),
    );
  }
}

class SpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;

  SpinnerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final barCount = 9;
    final barWidth = radius * 0.15;
    final barHeight = radius * 0.4;

    for (int i = 0; i < barCount; i++) {
      final angle = (i * 2 * 3.14159) / barCount;
      final rotationAngle = angle + (progress * 2 * 3.14159);
      
      // Calculate opacity based on position in the rotation
      final normalizedAngle = (rotationAngle % (2 * 3.14159)) / (2 * 3.14159);
      final opacity = _calculateOpacity(normalizedAngle);
      
      if (opacity > 0) {
        final paint = Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill;

        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(rotationAngle);
        
        // Draw rounded rectangle bar
        final rect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(0, -radius + barHeight / 2),
            width: barWidth,
            height: barHeight,
          ),
          Radius.circular(barWidth / 4),
        );
        
        canvas.drawRRect(rect, paint);
        canvas.restore();
      }
    }
  }

  double _calculateOpacity(double normalizedAngle) {
    // Create a gradient effect where bars fade in and out
    // The darkest bar is at position 0, and it fades as it moves around
    final fadeStart = 0.0;
    final fadeEnd = 0.5;
    
    if (normalizedAngle >= fadeStart && normalizedAngle <= fadeEnd) {
      // Fade in from 0 to 1
      return (normalizedAngle - fadeStart) / (fadeEnd - fadeStart);
    } else if (normalizedAngle > fadeEnd && normalizedAngle <= 1.0) {
      // Fade out from 1 to 0
      return 1.0 - ((normalizedAngle - fadeEnd) / (1.0 - fadeEnd));
    }
    
    return 0.0;
  }

  @override
  bool shouldRepaint(SpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
