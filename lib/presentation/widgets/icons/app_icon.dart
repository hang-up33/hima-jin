import 'package:flutter/widgets.dart';

import 'app_icon_painter.dart';
import 'app_icon_type.dart';

/// Renders a hand-drawn [AppIconType] the same way [Icon] renders an
/// [IconData] — a drop-in replacement for the emoji glyphs the app used to
/// show via `Text(emoji)`.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.type, {
    super.key,
    this.size = 24,
    this.color = const Color(0xFF2D2D2D),
    this.strokeWidth = 1.8,
  });

  final AppIconType type;
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: AppIconPainter(
        type: type,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
