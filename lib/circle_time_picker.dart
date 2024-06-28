import 'package:flutter/material.dart';
import 'dart:math';

class CircleTimePicker extends StatelessWidget {
  final TimeOfDay initialTime;
  final void Function(int hour, int minute) onTimeChange;

  const CircleTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChange,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: CircleTimePickerPainter(
        hour: initialTime.hour,
        minute: initialTime.minute,
        onTimeChange: onTimeChange,
      ),
    );
  }
}

class CircleTimePickerPainter extends CustomPainter {
  final int hour;
  final int minute;
  final void Function(int hour, int minute) onTimeChange;
  final double radius = 90.0;
  late Offset center;

  CircleTimePickerPainter({
    required this.hour,
    required this.minute,
    required this.onTimeChange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Draw outer circle
    canvas.drawCircle(center, radius, paint);

    // Draw hour hand
    final hourAngle = 2 * 3.14159265 * (hour / 12);
    final hourX = center.dx + radius * 0.5 * cos(hourAngle - 3.14159265 / 2);
    final hourY = center.dy + radius * 0.5 * sin(hourAngle - 3.14159265 / 2);
    canvas.drawLine(center, Offset(hourX, hourY), paint..strokeWidth = 6.0);

    // Draw minute hand
    final minuteAngle = 2 * 3.14159265 * (minute / 60);
    final minuteX =
        center.dx + radius * 0.8 * cos(minuteAngle - 3.14159265 / 2);
    final minuteY =
        center.dy + radius * 0.8 * sin(minuteAngle - 3.14159265 / 2);
    canvas.drawLine(center, Offset(minuteX, minuteY), paint..strokeWidth = 4.0);

    // Draw hour dots
    for (int i = 0; i < 12; i++) {
      final angle = 2 * 3.14159265 * (i / 12);
      final x = center.dx + radius * 0.9 * cos(angle - 3.14159265 / 2);
      final y = center.dy + radius * 0.9 * sin(angle - 3.14159265 / 2);
      canvas.drawCircle(Offset(x, y), 4.0, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool hitTest(Offset position) {
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);
    if (distance <= radius) {
      final angle = atan2(dy, dx) + 3.14159265 / 2;
      final newHour = ((angle / (2 * 3.14159265)) * 12).round() % 12;
      final newMinute = ((angle / (2 * 3.14159265)) * 60).round() % 60;
      onTimeChange(newHour, newMinute);
      return true;
    }
    return false;
  }

  @override
  bool shouldRepaint(covariant CustomPainteroldDelegate) {
    return true;
  }
}
