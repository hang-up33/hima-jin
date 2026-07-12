import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import 'app_icon_type.dart';

/// Draws a 24x24-logical-unit line icon for the given [AppIconType].
///
/// Every `_paintXxx` method draws inside a fixed 24x24 grid (origin top-left,
/// center at (12,12)); [paint] scales that grid to the widget's actual size.
class AppIconPainter extends CustomPainter {
  AppIconPainter({
    required this.type,
    required this.color,
    this.strokeWidth = 1.8,
  });

  final AppIconType type;
  final Color color;
  final double strokeWidth;

  static const double _gridSize = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _gridSize;
    canvas.save();
    canvas.scale(scale);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    switch (type) {
      case AppIconType.bathtub:
        _paintBathtub(canvas, stroke, fill);
        break;
      case AppIconType.bed:
        _paintBed(canvas, stroke, fill);
        break;
      case AppIconType.blackCircle:
        _paintBlackCircle(canvas, stroke, fill);
        break;
      case AppIconType.bookmark:
        _paintBookmark(canvas, stroke, fill);
        break;
      case AppIconType.books:
        _paintBooks(canvas, stroke, fill);
        break;
      case AppIconType.brain:
        _paintBrain(canvas, stroke, fill);
        break;
      case AppIconType.bubbles:
        _paintBubbles(canvas, stroke, fill);
        break;
      case AppIconType.calendar:
        _paintCalendar(canvas, stroke, fill);
        break;
      case AppIconType.calendarSpiral:
        _paintCalendarSpiral(canvas, stroke, fill);
        break;
      case AppIconType.calendarTear:
        _paintCalendarTear(canvas, stroke, fill);
        break;
      case AppIconType.chatBubble:
        _paintChatBubble(canvas, stroke, fill);
        break;
      case AppIconType.checkMark:
        _paintCheckMark(canvas, stroke, fill);
        break;
      case AppIconType.clapperboard:
        _paintClapperboard(canvas, stroke, fill);
        break;
      case AppIconType.clipboard:
        _paintClipboard(canvas, stroke, fill);
        break;
      case AppIconType.clock:
        _paintClock(canvas, stroke, fill);
        break;
      case AppIconType.cloud:
        _paintCloud(canvas, stroke, fill);
        break;
      case AppIconType.coffee:
        _paintCoffee(canvas, stroke, fill);
        break;
      case AppIconType.cooking:
        _paintCooking(canvas, stroke, fill);
        break;
      case AppIconType.crown:
        _paintCrown(canvas, stroke, fill);
        break;
      case AppIconType.dizzyStars:
        _paintDizzyStars(canvas, stroke, fill);
        break;
      case AppIconType.eye:
        _paintEye(canvas, stroke, fill);
        break;
      case AppIconType.fire:
        _paintFire(canvas, stroke, fill);
        break;
      case AppIconType.fog:
        _paintFog(canvas, stroke, fill);
        break;
      case AppIconType.footprint:
        _paintFootprint(canvas, stroke, fill);
        break;
      case AppIconType.galaxy:
        _paintGalaxy(canvas, stroke, fill);
        break;
      case AppIconType.gameController:
        _paintGameController(canvas, stroke, fill);
        break;
      case AppIconType.globe:
        _paintGlobe(canvas, stroke, fill);
        break;
      case AppIconType.headphones:
        _paintHeadphones(canvas, stroke, fill);
        break;
      case AppIconType.hikingBoot:
        _paintHikingBoot(canvas, stroke, fill);
        break;
      case AppIconType.hole:
        _paintHole(canvas, stroke, fill);
        break;
      case AppIconType.hundred:
        _paintHundred(canvas, stroke, fill);
        break;
      case AppIconType.joystick:
        _paintJoystick(canvas, stroke, fill);
        break;
      case AppIconType.lock:
        _paintLock(canvas, stroke, fill);
        break;
      case AppIconType.map:
        _paintMap(canvas, stroke, fill);
        break;
      case AppIconType.medal:
        _paintMedal(canvas, stroke, fill);
        break;
      case AppIconType.meditation:
        _paintMeditation(canvas, stroke, fill);
        break;
      case AppIconType.moon:
        _paintMoon(canvas, stroke, fill);
        break;
      case AppIconType.mountain:
        _paintMountain(canvas, stroke, fill);
        break;
      case AppIconType.muscle:
        _paintMuscle(canvas, stroke, fill);
        break;
      case AppIconType.musicNote:
        _paintMusicNote(canvas, stroke, fill);
        break;
      case AppIconType.musicNotes:
        _paintMusicNotes(canvas, stroke, fill);
        break;
      case AppIconType.nap:
        _paintNap(canvas, stroke, fill);
        break;
      case AppIconType.nightCity:
        _paintNightCity(canvas, stroke, fill);
        break;
      case AppIconType.openBook:
        _paintOpenBook(canvas, stroke, fill);
        break;
      case AppIconType.owl:
        _paintOwl(canvas, stroke, fill);
        break;
      case AppIconType.paintbrush:
        _paintPaintbrush(canvas, stroke, fill);
        break;
      case AppIconType.palette:
        _paintPalette(canvas, stroke, fill);
        break;
      case AppIconType.partlyCloudy:
        _paintPartlyCloudy(canvas, stroke, fill);
        break;
      case AppIconType.pencil:
        _paintPencil(canvas, stroke, fill);
        break;
      case AppIconType.pin:
        _paintPin(canvas, stroke, fill);
        break;
      case AppIconType.popcorn:
        _paintPopcorn(canvas, stroke, fill);
        break;
      case AppIconType.princess:
        _paintPrincess(canvas, stroke, fill);
        break;
      case AppIconType.rainbow:
        _paintRainbow(canvas, stroke, fill);
        break;
      case AppIconType.rock:
        _paintRock(canvas, stroke, fill);
        break;
      case AppIconType.running:
        _paintRunning(canvas, stroke, fill);
        break;
      case AppIconType.shoe:
        _paintShoe(canvas, stroke, fill);
        break;
      case AppIconType.shoppingBags:
        _paintShoppingBags(canvas, stroke, fill);
        break;
      case AppIconType.shower:
        _paintShower(canvas, stroke, fill);
        break;
      case AppIconType.sleepZzz:
        _paintSleepZzz(canvas, stroke, fill);
        break;
      case AppIconType.sleepyFace:
        _paintSleepyFace(canvas, stroke, fill);
        break;
      case AppIconType.sparkles:
        _paintSparkles(canvas, stroke, fill);
        break;
      case AppIconType.speakingHead:
        _paintSpeakingHead(canvas, stroke, fill);
        break;
      case AppIconType.speechBubble:
        _paintSpeechBubble(canvas, stroke, fill);
        break;
      case AppIconType.star:
        _paintStar(canvas, stroke, fill);
        break;
      case AppIconType.store:
        _paintStore(canvas, stroke, fill);
        break;
      case AppIconType.sun:
        _paintSun(canvas, stroke, fill);
        break;
      case AppIconType.sunrise:
        _paintSunrise(canvas, stroke, fill);
        break;
      case AppIconType.sunriseMountain:
        _paintSunriseMountain(canvas, stroke, fill);
        break;
      case AppIconType.target:
        _paintTarget(canvas, stroke, fill);
        break;
      case AppIconType.trophy:
        _paintTrophy(canvas, stroke, fill);
        break;
      case AppIconType.tv:
        _paintTv(canvas, stroke, fill);
        break;
      case AppIconType.walk:
        _paintWalk(canvas, stroke, fill);
        break;
      case AppIconType.weightlifting:
        _paintWeightlifting(canvas, stroke, fill);
        break;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AppIconPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;

  // ===== Icon drawing methods (24x24 grid, center 12,12) =====

  void _paintBathtub(Canvas canvas, Paint stroke, Paint fill) {
      final basin = RRect.fromRectAndRadius(
        const Rect.fromLTRB(4, 9, 20, 18),
        const Radius.circular(4),
      );
      canvas.drawRRect(basin, stroke);
      // feet
      canvas.drawLine(const Offset(6.5, 18), const Offset(6.5, 20), stroke);
      canvas.drawLine(const Offset(17.5, 18), const Offset(17.5, 20), stroke);
      // water wave
      final wave = Path()
        ..moveTo(6.5, 13)
        ..quadraticBezierTo(8.5, 11, 10.5, 13)
        ..quadraticBezierTo(12.5, 15, 14.5, 13)
        ..quadraticBezierTo(16.5, 11, 18, 12.5);
      canvas.drawPath(wave, stroke);
      // bubbles
      canvas.drawCircle(const Offset(9, 15.5), 0.9, stroke);
      canvas.drawCircle(const Offset(13, 16), 0.7, stroke);
    }

  void _paintBed(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawLine(const Offset(3, 19), const Offset(21, 19), stroke);
    canvas.drawLine(const Offset(4, 19), const Offset(4, 21), stroke);
    canvas.drawLine(const Offset(20, 19), const Offset(20, 21), stroke);
    final mattress = Path()
      ..moveTo(3, 19)
      ..lineTo(3, 13)
      ..lineTo(21, 13)
      ..lineTo(21, 19);
    canvas.drawPath(mattress, stroke);
    final pillow = RRect.fromRectAndRadius(
      const Rect.fromLTWH(4, 10.5, 6, 5),
      const Radius.circular(2),
    );
    canvas.drawRRect(pillow, stroke);
    canvas.drawLine(const Offset(11, 13), const Offset(11, 19), stroke);
  }

  void _paintBlackCircle(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(12, 12), 8, fill);
  }

  void _paintBookmark(Canvas canvas, Paint stroke, Paint fill) {
    final path = Path()
      ..moveTo(9, 3)
      ..lineTo(15, 3)
      ..lineTo(15, 19)
      ..lineTo(12, 16)
      ..lineTo(9, 19)
      ..close();
    canvas.drawPath(path, stroke);
  }

  void _paintBooks(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawRect(const Rect.fromLTRB(4, 15, 20, 18), stroke);
    canvas.drawLine(const Offset(4, 16.5), const Offset(20, 16.5), stroke);
    canvas.drawRect(const Rect.fromLTRB(5, 11, 19, 14.5), stroke);
    canvas.drawLine(const Offset(5, 12.7), const Offset(19, 12.7), stroke);
    canvas.save();
    canvas.translate(12, 9);
    canvas.rotate(-0.08);
    canvas.translate(-12, -9);
    canvas.drawRect(const Rect.fromLTRB(6, 7, 18, 10.5), stroke);
    canvas.restore();
  }

  void _paintBrain(Canvas canvas, Paint stroke, Paint fill) {
      // left lobe
      final left = Path()
        ..moveTo(12, 6)
        ..cubicTo(8, 5, 4, 8, 5, 12)
        ..cubicTo(4, 16, 8, 19, 12, 17.5);
      canvas.drawPath(left, stroke);
      // right lobe
      final right = Path()
        ..moveTo(12, 6)
        ..cubicTo(16, 5, 20, 8, 19, 12)
        ..cubicTo(20, 16, 16, 19, 12, 17.5);
      canvas.drawPath(right, stroke);
      // squiggle folds
      final squiggle1 = Path()
        ..moveTo(7, 10)
        ..quadraticBezierTo(9, 8.5, 11, 10)
        ..quadraticBezierTo(13, 11.5, 15, 10);
      canvas.drawPath(squiggle1, stroke);
      final squiggle2 = Path()
        ..moveTo(7, 13.5)
        ..quadraticBezierTo(9, 12, 11, 13.5)
        ..quadraticBezierTo(13, 15, 15, 13.5);
      canvas.drawPath(squiggle2, stroke);
    }

  void _paintBubbles(Canvas canvas, Paint stroke, Paint fill) {
      canvas.drawCircle(const Offset(9, 14), 4, stroke);
      canvas.drawCircle(const Offset(15.5, 11), 3, stroke);
      canvas.drawCircle(const Offset(13.5, 17.5), 2.3, stroke);
      canvas.drawCircle(const Offset(17.5, 16.5), 1.8, stroke);
      // highlight
      canvas.drawCircle(const Offset(7.5, 12.5), 0.6, fill);
    }

  void _paintCalendar(Canvas canvas, Paint stroke, Paint fill) {
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 5, 18, 16),
      const Radius.circular(2),
    );
    canvas.drawRRect(body, stroke);
    canvas.drawLine(const Offset(3, 9.5), const Offset(21, 9.5), stroke);
    canvas.drawLine(const Offset(8, 3), const Offset(8, 6.5), stroke);
    canvas.drawLine(const Offset(16, 3), const Offset(16, 6.5), stroke);
  }

  void _paintCalendarSpiral(Canvas canvas, Paint stroke, Paint fill) {
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 6, 18, 15),
      const Radius.circular(2),
    );
    canvas.drawRRect(body, stroke);
    canvas.drawLine(const Offset(3, 10.5), const Offset(21, 10.5), stroke);
    canvas.drawCircle(const Offset(7, 5), 1.3, stroke);
    canvas.drawCircle(const Offset(12, 5), 1.3, stroke);
    canvas.drawCircle(const Offset(17, 5), 1.3, stroke);
  }

  void _paintCalendarTear(Canvas canvas, Paint stroke, Paint fill) {
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 4, 18, 16),
      const Radius.circular(2),
    );
    canvas.drawRRect(body, stroke);
    canvas.drawLine(const Offset(3, 8.5), const Offset(21, 8.5), stroke);
    final fold = Path()
      ..moveTo(21, 20)
      ..lineTo(17, 20)
      ..lineTo(21, 16)
      ..close();
    canvas.drawPath(fold, stroke);
  }

  void _paintChatBubble(Canvas canvas, Paint stroke, Paint fill) {
    final bubble = RRect.fromRectAndRadius(
      const Rect.fromLTRB(4, 4, 20, 16),
      const Radius.circular(3),
    );
    canvas.drawRRect(bubble, stroke);

    final tail = Path()
      ..moveTo(6, 15.5)
      ..lineTo(4, 20)
      ..lineTo(9.5, 16);
    canvas.drawPath(tail, stroke);
  }

  void _paintCheckMark(Canvas canvas, Paint stroke, Paint fill) {
    final box = RRect.fromRectAndRadius(
      const Rect.fromLTRB(4, 4, 20, 20),
      const Radius.circular(4),
    );
    canvas.drawRRect(box, stroke);

    final check = Path()
      ..moveTo(8, 12.5)
      ..lineTo(11, 16)
      ..lineTo(17, 8.5);
    canvas.drawPath(check, stroke);
  }

  void _paintClapperboard(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawRect(const Rect.fromLTRB(4, 10, 20, 20), stroke);
    final topBar = Path()
      ..moveTo(3.5, 10)
      ..lineTo(6, 5)
      ..lineTo(20.5, 5)
      ..lineTo(20.5, 10)
      ..close();
    canvas.drawPath(topBar, stroke);
    canvas.drawLine(const Offset(8, 10), const Offset(9.5, 5.3), stroke);
    canvas.drawLine(const Offset(12, 10), const Offset(13.5, 5.3), stroke);
    canvas.drawLine(const Offset(16, 10), const Offset(17.5, 5.3), stroke);
  }

  void _paintClipboard(Canvas canvas, Paint stroke, Paint fill) {
    final board = RRect.fromRectAndRadius(
      const Rect.fromLTRB(5, 5, 19, 20),
      const Radius.circular(2),
    );
    canvas.drawRRect(board, stroke);

    final tab = RRect.fromRectAndRadius(
      const Rect.fromLTRB(9, 3, 15, 6.5),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(tab, stroke);

    canvas.drawLine(const Offset(8, 10), const Offset(16, 10), stroke);
    canvas.drawLine(const Offset(8, 13.5), const Offset(16, 13.5), stroke);
    canvas.drawLine(const Offset(8, 17), const Offset(14, 17), stroke);
  }

  void _paintClock(Canvas canvas, Paint stroke, Paint fill) {
    final leftBell = Path()
      ..moveTo(5, 5)
      ..quadraticBezierTo(6, 2, 8, 3);
    canvas.drawPath(leftBell, stroke);
    final rightBell = Path()
      ..moveTo(19, 5)
      ..quadraticBezierTo(18, 2, 16, 3);
    canvas.drawPath(rightBell, stroke);
    canvas.drawCircle(const Offset(12, 13), 8, stroke);
    canvas.drawLine(const Offset(12, 13), const Offset(12, 9), stroke);
    canvas.drawLine(const Offset(12, 13), const Offset(15, 13), stroke);
    canvas.drawCircle(const Offset(12, 13), 0.6, fill);
  }

  void _paintCloud(Canvas canvas, Paint stroke, Paint fill) {
      final Path path = Path();
      path.moveTo(6, 17);
      path.quadraticBezierTo(3, 17, 3, 14);
      path.quadraticBezierTo(3, 11, 6.5, 11);
      path.quadraticBezierTo(7, 7.5, 11, 8);
      path.quadraticBezierTo(14, 6, 17, 9);
      path.quadraticBezierTo(21, 9, 21, 13);
      path.quadraticBezierTo(21, 16.5, 17.5, 17);
      path.lineTo(6, 17);
      path.close();
      canvas.drawPath(path, stroke);
    }

  void _paintCoffee(Canvas canvas, Paint stroke, Paint fill) {
    final cupPath = Path()
      ..moveTo(6, 9)
      ..lineTo(17, 9)
      ..lineTo(16, 19)
      ..quadraticBezierTo(11.5, 21, 7, 19)
      ..close();
    canvas.drawPath(cupPath, stroke);

    canvas.drawArc(const Rect.fromLTWH(15, 10, 6, 7), -1.2, 2.4, false, stroke);

    final steam1 = Path()
      ..moveTo(9, 8)
      ..quadraticBezierTo(7.5, 6, 9, 4.5)
      ..quadraticBezierTo(10.5, 3, 9, 2);
    canvas.drawPath(steam1, stroke);

    final steam2 = Path()
      ..moveTo(13, 8)
      ..quadraticBezierTo(11.5, 6, 13, 4.5)
      ..quadraticBezierTo(14.5, 3, 13, 2);
    canvas.drawPath(steam2, stroke);
  }

  void _paintCooking(Canvas canvas, Paint stroke, Paint fill) {
    final panRect = Rect.fromCenter(center: const Offset(11, 13), width: 14, height: 10);
    canvas.drawOval(panRect, stroke);

    canvas.drawLine(const Offset(18, 13), const Offset(21, 12), stroke);

    final eggWhite = Path()
      ..moveTo(8, 13)
      ..quadraticBezierTo(7, 10.5, 10, 10.5)
      ..quadraticBezierTo(13, 10, 14, 12.5)
      ..quadraticBezierTo(15, 15, 12, 15.5)
      ..quadraticBezierTo(8.5, 16, 8, 13)
      ..close();
    canvas.drawPath(eggWhite, stroke);

    canvas.drawCircle(const Offset(11, 13), 1.6, fill);
  }

  void _paintCrown(Canvas canvas, Paint stroke, Paint fill) {
    final band = Path()
      ..moveTo(4, 18)
      ..lineTo(4, 11)
      ..lineTo(8, 14.5)
      ..lineTo(12, 7)
      ..lineTo(16, 14.5)
      ..lineTo(20, 11)
      ..lineTo(20, 18)
      ..close();
    canvas.drawPath(band, stroke);
    canvas.drawCircle(const Offset(4, 10), 1, fill);
    canvas.drawCircle(const Offset(12, 6), 1, fill);
    canvas.drawCircle(const Offset(20, 10), 1, fill);
    canvas.drawLine(const Offset(4, 15.5), const Offset(20, 15.5), stroke);
  }

  void _paintDizzyStars(Canvas canvas, Paint stroke, Paint fill) {
      const Offset center = Offset(11, 14);
      const double radius = 6;
      final Rect rect = Rect.fromCircle(center: center, radius: radius);
      const double startAngle = -math.pi * 0.1;
      const double sweepAngle = math.pi * 1.6;
      final Path trail = Path()..addArc(rect, startAngle, sweepAngle);
      canvas.drawPath(trail, stroke);

      final double endAngle = startAngle + sweepAngle;
      final double ex = center.dx + radius * math.cos(endAngle);
      final double ey = center.dy + radius * math.sin(endAngle);
      const double r = 1.6;
      final Path sp = Path();
      sp.moveTo(ex, ey - r);
      sp.quadraticBezierTo(ex, ey, ex + r, ey);
      sp.quadraticBezierTo(ex, ey, ex, ey + r);
      sp.quadraticBezierTo(ex, ey, ex - r, ey);
      sp.quadraticBezierTo(ex, ey, ex, ey - r);
      sp.close();
      canvas.drawPath(sp, fill);

      canvas.drawCircle(const Offset(6, 8), 0.6, fill);
      canvas.drawCircle(const Offset(9, 6), 0.4, fill);
    }

  void _paintEye(Canvas canvas, Paint stroke, Paint fill) {
    final almond = Path()
      ..moveTo(3, 12)
      ..quadraticBezierTo(12, 4, 21, 12)
      ..quadraticBezierTo(12, 20, 3, 12)
      ..close();
    canvas.drawPath(almond, stroke);
    canvas.drawCircle(const Offset(12, 12), 3, fill);
  }

  void _paintFire(Canvas canvas, Paint stroke, Paint fill) {
    final outer = Path()
      ..moveTo(12, 3)
      ..quadraticBezierTo(17, 9, 15, 13)
      ..quadraticBezierTo(18, 12, 18, 15)
      ..quadraticBezierTo(18, 20.5, 12, 20.5)
      ..quadraticBezierTo(6, 20.5, 6, 15)
      ..quadraticBezierTo(6, 12, 8, 10)
      ..quadraticBezierTo(8, 13, 10, 12)
      ..quadraticBezierTo(7, 7, 12, 3)
      ..close();
    canvas.drawPath(outer, stroke);
    final inner = Path()
      ..moveTo(12, 11)
      ..quadraticBezierTo(14, 14, 12.5, 17)
      ..quadraticBezierTo(10, 15, 12, 11)
      ..close();
    canvas.drawPath(inner, stroke);
  }

  void _paintFog(Canvas canvas, Paint stroke, Paint fill) {
      final List<double> ys = <double>[7, 12, 17];
      for (final double y in ys) {
        final Path path = Path();
        path.moveTo(3, y);
        path.quadraticBezierTo(7, y - 1.5, 12, y);
        path.quadraticBezierTo(17, y + 1.5, 21, y);
        canvas.drawPath(path, stroke);
      }
    }

  void _paintFootprint(Canvas canvas, Paint stroke, Paint fill) {
      final sole = Path()
        ..moveTo(12, 9)
        ..cubicTo(16, 9, 17, 13, 15.5, 17)
        ..cubicTo(14.5, 20, 10, 20.5, 9, 17.5)
        ..cubicTo(7.5, 13.5, 8.5, 9.5, 12, 9)
        ..close();
      canvas.drawPath(sole, stroke);
      // toe bumps
      canvas.drawCircle(const Offset(9.5, 6.5), 1.1, stroke);
      canvas.drawCircle(const Offset(12, 5.5), 1.2, stroke);
      canvas.drawCircle(const Offset(14.5, 6.2), 1.1, stroke);
      canvas.drawCircle(const Offset(16.3, 8), 0.9, stroke);
    }

  void _paintGalaxy(Canvas canvas, Paint stroke, Paint fill) {
      final Path spiral = Path();
      spiral.moveTo(19, 8);
      spiral.quadraticBezierTo(21, 12, 16, 15);
      spiral.quadraticBezierTo(11, 18, 8, 13);
      spiral.quadraticBezierTo(6, 9, 11, 8);
      spiral.quadraticBezierTo(14, 7.5, 13, 11);
      canvas.drawPath(spiral, stroke);

      canvas.drawCircle(const Offset(5, 6), 0.7, fill);
      canvas.drawCircle(const Offset(19, 18), 0.6, fill);
      canvas.drawCircle(const Offset(4, 17), 0.5, fill);
    }

  void _paintGameController(Canvas canvas, Paint stroke, Paint fill) {
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTRB(3, 9, 21, 17),
      const Radius.circular(4),
    );
    canvas.drawRRect(body, stroke);
    canvas.drawLine(const Offset(8, 11), const Offset(8, 15), stroke);
    canvas.drawLine(const Offset(6, 13), const Offset(10, 13), stroke);
    canvas.drawCircle(const Offset(15.5, 11.5), 1.1, fill);
    canvas.drawCircle(const Offset(18, 14), 1.1, fill);
  }

  void _paintGlobe(Canvas canvas, Paint stroke, Paint fill) {
      canvas.drawCircle(const Offset(12, 12), 8, stroke);

      final Path meridian = Path();
      meridian.moveTo(12, 4);
      meridian.quadraticBezierTo(18, 12, 12, 20);
      canvas.drawPath(meridian, stroke);

      final Path lat1 = Path();
      lat1.moveTo(4.5, 8.5);
      lat1.quadraticBezierTo(12, 10.5, 19.5, 8.5);
      canvas.drawPath(lat1, stroke);

      final Path lat2 = Path();
      lat2.moveTo(4.5, 15.5);
      lat2.quadraticBezierTo(12, 17.5, 19.5, 15.5);
      canvas.drawPath(lat2, stroke);
    }

  void _paintHeadphones(Canvas canvas, Paint stroke, Paint fill) {
    final band = Path()
      ..addArc(const Rect.fromLTRB(4, 4, 20, 20), math.pi, math.pi);
    canvas.drawPath(band, stroke);
    final leftCup = RRect.fromRectAndRadius(
      const Rect.fromLTRB(3, 13, 7, 19),
      const Radius.circular(2),
    );
    canvas.drawRRect(leftCup, stroke);
    final rightCup = RRect.fromRectAndRadius(
      const Rect.fromLTRB(17, 13, 21, 19),
      const Radius.circular(2),
    );
    canvas.drawRRect(rightCup, stroke);
  }

  void _paintHikingBoot(Canvas canvas, Paint stroke, Paint fill) {
      final boot = Path()
        ..moveTo(4, 19)
        ..lineTo(18, 19)
        ..quadraticBezierTo(20, 19, 19.5, 16)
        ..quadraticBezierTo(19, 13.5, 15.5, 12.5)
        ..lineTo(15, 5)
        ..lineTo(11, 5)
        ..lineTo(10.5, 10.5)
        ..quadraticBezierTo(7, 11, 5.5, 13.5)
        ..quadraticBezierTo(4.3, 16, 4, 19)
        ..close();
      canvas.drawPath(boot, stroke);
      // thick sole line
      canvas.drawLine(const Offset(4, 19.7), const Offset(19.3, 19.7), stroke);
      // laces/straps
      canvas.drawLine(const Offset(11.3, 7), const Offset(14.7, 7), stroke);
      canvas.drawLine(const Offset(11.3, 9), const Offset(14.7, 9), stroke);
      canvas.drawLine(const Offset(11.3, 11), const Offset(14.7, 11), stroke);
    }

  void _paintHole(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawOval(const Rect.fromLTRB(7.5, 12.5, 16.5, 16.5), fill);
    canvas.drawOval(const Rect.fromLTRB(5, 10.5, 19, 17.5), stroke);
    canvas.drawOval(const Rect.fromLTRB(3, 9, 21, 18.5), stroke);
  }

  void _paintHundred(Canvas canvas, Paint stroke, Paint fill) {
    const center = Offset(12, 12);
    canvas.drawCircle(center, 8, stroke);

    const points = 8;
    for (var i = 0; i < points; i++) {
      final angle = (math.pi * 2 / points) * i;
      final inner = Offset(
        center.dx + math.cos(angle) * 2.5,
        center.dy + math.sin(angle) * 2.5,
      );
      final outer = Offset(
        center.dx + math.cos(angle) * 6.5,
        center.dy + math.sin(angle) * 6.5,
      );
      canvas.drawLine(inner, outer, stroke);
    }
  }

  void _paintJoystick(Canvas canvas, Paint stroke, Paint fill) {
    final base = RRect.fromRectAndRadius(
      const Rect.fromLTRB(6, 17, 18, 20.5),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(base, stroke);
    canvas.drawLine(const Offset(12, 17), const Offset(12, 8), stroke);
    canvas.drawCircle(const Offset(12, 6), 2.5, stroke);
  }

  void _paintLock(Canvas canvas, Paint stroke, Paint fill) {
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTRB(5, 11, 19, 20),
      const Radius.circular(2),
    );
    canvas.drawRRect(body, stroke);
    final shackle = Path()
      ..moveTo(7.5, 11)
      ..lineTo(7.5, 8)
      ..quadraticBezierTo(7.5, 4, 12, 4)
      ..quadraticBezierTo(16.5, 4, 16.5, 8)
      ..lineTo(16.5, 11);
    canvas.drawPath(shackle, stroke);
    canvas.drawCircle(const Offset(12, 14.5), 1.3, fill);
    canvas.drawLine(const Offset(12, 15.5), const Offset(12, 17.5), stroke);
  }

  void _paintMap(Canvas canvas, Paint stroke, Paint fill) {
    final outline = Path()
      ..moveTo(4, 6)
      ..lineTo(20, 5)
      ..lineTo(20, 19)
      ..lineTo(4, 20)
      ..close();
    canvas.drawPath(outline, stroke);
    canvas.drawLine(const Offset(9.5, 5.5), const Offset(9.5, 19.5), stroke);
    canvas.drawLine(const Offset(15, 5.2), const Offset(15, 19.8), stroke);
    canvas.drawLine(const Offset(11.5, 10.5), const Offset(13.5, 12.5), stroke);
    canvas.drawLine(const Offset(13.5, 10.5), const Offset(11.5, 12.5), stroke);
  }

  void _paintMedal(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(12, 9), 5.5, stroke);
    canvas.drawLine(const Offset(9.5, 9), const Offset(14.5, 9), stroke);
    canvas.drawLine(const Offset(12, 6.5), const Offset(12, 11.5), stroke);
    canvas.drawLine(const Offset(9, 13.5), const Offset(7.5, 21), stroke);
    canvas.drawLine(const Offset(15, 13.5), const Offset(16.5, 21), stroke);
  }

  void _paintMeditation(Canvas canvas, Paint stroke, Paint fill) {
      // head
      canvas.drawCircle(const Offset(12, 6.5), 2, stroke);
      // seated body with wide folded-leg base
      final body = Path()
        ..moveTo(12, 9)
        ..quadraticBezierTo(9, 11, 6, 18)
        ..lineTo(18, 18)
        ..quadraticBezierTo(15, 11, 12, 9)
        ..close();
      canvas.drawPath(body, stroke);
    }

  void _paintMoon(Canvas canvas, Paint stroke, Paint fill) {
    final outer = Path()
      ..addOval(const Rect.fromLTWH(3, 4, 16, 16));
    final inner = Path()
      ..addOval(const Rect.fromLTWH(7, 1, 16, 16));
    final crescent = Path.combine(PathOperation.difference, outer, inner);
    canvas.drawPath(crescent, fill);
  }

  void _paintMountain(Canvas canvas, Paint stroke, Paint fill) {
      final Path tall = Path();
      tall.moveTo(15, 5);
      tall.lineTo(21, 19);
      tall.lineTo(9, 19);
      tall.close();
      canvas.drawPath(tall, stroke);

      final Path short = Path();
      short.moveTo(7, 10);
      short.lineTo(13, 19);
      short.lineTo(3, 19);
      short.close();
      canvas.drawPath(short, stroke);
    }

  void _paintMuscle(Canvas canvas, Paint stroke, Paint fill) {
      // fist
      canvas.drawCircle(const Offset(6.5, 18), 2.3, stroke);
      // forearm up to elbow
      canvas.drawLine(const Offset(8, 16), const Offset(10.5, 11.5), stroke);
      // bicep bulge curve to shoulder and back down
      final bicep = Path()
        ..moveTo(10.5, 11.5)
        ..quadraticBezierTo(11.5, 6, 16.5, 6)
        ..quadraticBezierTo(19.5, 6.2, 18, 10)
        ..quadraticBezierTo(16.5, 12.5, 13, 12.5);
      canvas.drawPath(bicep, stroke);
    }

  void _paintMusicNote(Canvas canvas, Paint stroke, Paint fill) {
    final notehead = Rect.fromCenter(
      center: const Offset(9, 17),
      width: 5,
      height: 3.6,
    );
    canvas.save();
    canvas.translate(9, 17);
    canvas.rotate(-0.3);
    canvas.translate(-9, -17);
    canvas.drawOval(notehead, fill);
    canvas.restore();
    canvas.drawLine(const Offset(11.4, 16.3), const Offset(11.4, 5), stroke);
    final flag = Path()
      ..moveTo(11.4, 5)
      ..quadraticBezierTo(16.5, 6.5, 15, 11);
    canvas.drawPath(flag, stroke);
  }

  void _paintMusicNotes(Canvas canvas, Paint stroke, Paint fill) {
    final note1 = Rect.fromCenter(
      center: const Offset(8, 18),
      width: 4.2,
      height: 3.2,
    );
    final note2 = Rect.fromCenter(
      center: const Offset(14, 19),
      width: 4.2,
      height: 3.2,
    );
    canvas.save();
    canvas.translate(8, 18);
    canvas.rotate(-0.25);
    canvas.translate(-8, -18);
    canvas.drawOval(note1, fill);
    canvas.restore();
    canvas.save();
    canvas.translate(14, 19);
    canvas.rotate(-0.25);
    canvas.translate(-14, -19);
    canvas.drawOval(note2, fill);
    canvas.restore();
    canvas.drawLine(const Offset(10, 17.3), const Offset(10, 5.5), stroke);
    canvas.drawLine(const Offset(16, 18.3), const Offset(16, 6.5), stroke);
    canvas.drawLine(const Offset(10, 5.5), const Offset(16, 6.5), stroke);
  }

  void _paintNap(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(12, 12), 8, stroke);
    final leftEye = Path()
      ..moveTo(8, 11)
      ..quadraticBezierTo(9.5, 13, 11, 11);
    canvas.drawPath(leftEye, stroke);
    final rightEye = Path()
      ..moveTo(13, 11)
      ..quadraticBezierTo(14.5, 13, 16, 11);
    canvas.drawPath(rightEye, stroke);
    final mouth = Path()
      ..moveTo(10.5, 16)
      ..quadraticBezierTo(12, 17, 13.5, 16);
    canvas.drawPath(mouth, stroke);
  }

  void _paintNightCity(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawLine(const Offset(2, 20), const Offset(22, 20), stroke);
    canvas.drawRect(const Rect.fromLTWH(3, 13, 4, 7), stroke);
    canvas.drawRect(const Rect.fromLTWH(8, 9, 4, 11), stroke);
    canvas.drawRect(const Rect.fromLTWH(13, 15, 4, 5), stroke);
    canvas.drawRect(const Rect.fromLTWH(18, 11, 3, 9), stroke);
    canvas.drawCircle(const Offset(17, 5), 1, fill);
  }

  void _paintOpenBook(Canvas canvas, Paint stroke, Paint fill) {
    final leftPage = Path()
      ..moveTo(12, 6)
      ..lineTo(4, 7.5)
      ..lineTo(4, 18)
      ..lineTo(12, 17)
      ..close();
    canvas.drawPath(leftPage, stroke);

    final rightPage = Path()
      ..moveTo(12, 6)
      ..lineTo(20, 7.5)
      ..lineTo(20, 18)
      ..lineTo(12, 17)
      ..close();
    canvas.drawPath(rightPage, stroke);

    canvas.drawLine(const Offset(12, 6), const Offset(12, 17), stroke);

    canvas.drawLine(const Offset(6.5, 10.5), const Offset(10, 10), stroke);
    canvas.drawLine(const Offset(6.5, 13), const Offset(10, 12.5), stroke);

    canvas.drawLine(const Offset(14, 10), const Offset(17.5, 10.5), stroke);
    canvas.drawLine(const Offset(14, 12.5), const Offset(17.5, 13), stroke);
  }

  void _paintOwl(Canvas canvas, Paint stroke, Paint fill) {
    final body = Path()
      ..moveTo(5, 20)
      ..quadraticBezierTo(4, 11, 12, 10)
      ..quadraticBezierTo(20, 11, 19, 20)
      ..close();
    canvas.drawPath(body, stroke);
    canvas.drawCircle(const Offset(9, 12.5), 2.6, stroke);
    canvas.drawCircle(const Offset(15, 12.5), 2.6, stroke);
    canvas.drawCircle(const Offset(9, 12.5), 0.9, fill);
    canvas.drawCircle(const Offset(15, 12.5), 0.9, fill);
    final beak = Path()
      ..moveTo(11, 14.5)
      ..lineTo(12, 16.5)
      ..lineTo(13, 14.5)
      ..close();
    canvas.drawPath(beak, stroke);
    canvas.drawLine(const Offset(7, 9), const Offset(8.5, 6), stroke);
    canvas.drawLine(const Offset(17, 9), const Offset(15.5, 6), stroke);
  }

  void _paintPaintbrush(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawLine(const Offset(6, 20), const Offset(15, 11), stroke);
    final tip = Path()
      ..moveTo(14, 12)
      ..lineTo(19, 5)
      ..lineTo(20.5, 6.5)
      ..lineTo(16, 13.5)
      ..close();
    canvas.drawPath(tip, stroke);
  }

  void _paintPalette(Canvas canvas, Paint stroke, Paint fill) {
    final blob = Path()
      ..moveTo(12, 4)
      ..quadraticBezierTo(20, 4, 20, 12)
      ..quadraticBezierTo(20, 18, 15, 18)
      ..quadraticBezierTo(13, 18, 13, 16)
      ..quadraticBezierTo(13, 14.5, 15, 14.5)
      ..quadraticBezierTo(16.5, 14.5, 16.5, 13)
      ..quadraticBezierTo(16.5, 11, 14, 11)
      ..quadraticBezierTo(4, 11, 4, 8)
      ..quadraticBezierTo(4, 4, 12, 4)
      ..close();
    canvas.drawPath(blob, stroke);
    canvas.drawCircle(const Offset(9, 7.5), 1, fill);
    canvas.drawCircle(const Offset(15, 7), 1, fill);
    canvas.drawCircle(const Offset(7, 12.5), 1, fill);
  }

  void _paintPartlyCloudy(Canvas canvas, Paint stroke, Paint fill) {
      const double sx = 8;
      const double sy = 8;
      const double sr = 2.2;
      final List<double> rayAngles = <double>[
        -math.pi / 2,
        -math.pi / 4,
        -3 * math.pi / 4,
        math.pi,
      ];
      for (final double a in rayAngles) {
        final double x1 = sx + (sr + 0.8) * math.cos(a);
        final double y1 = sy + (sr + 0.8) * math.sin(a);
        final double x2 = sx + (sr + 2.3) * math.cos(a);
        final double y2 = sy + (sr + 2.3) * math.sin(a);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), stroke);
      }
      canvas.drawCircle(const Offset(sx, sy), sr, stroke);

      final Path cloud = Path();
      cloud.moveTo(11, 19);
      cloud.quadraticBezierTo(9, 19, 9, 17);
      cloud.quadraticBezierTo(9, 15, 11, 15);
      cloud.quadraticBezierTo(11.5, 13, 13.5, 13.3);
      cloud.quadraticBezierTo(15.5, 12, 17, 13.5);
      cloud.quadraticBezierTo(19.5, 13.5, 19.5, 15.5);
      cloud.quadraticBezierTo(19.5, 18, 17, 19);
      cloud.lineTo(11, 19);
      cloud.close();
      canvas.drawPath(cloud, stroke);
    }

  void _paintPencil(Canvas canvas, Paint stroke, Paint fill) {
    final body = Path()
      ..moveTo(5, 19)
      ..lineTo(14, 10)
      ..lineTo(17, 13)
      ..lineTo(8, 22)
      ..close();
    canvas.drawPath(body, stroke);
    final tip = Path()
      ..moveTo(14, 10)
      ..lineTo(16, 5)
      ..lineTo(18.5, 7.5)
      ..lineTo(17, 13)
      ..close();
    canvas.drawPath(tip, stroke);
    canvas.drawLine(const Offset(6.5, 17.5), const Offset(9.5, 20.5), stroke);
  }

  void _paintPin(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(12, 8), 4.5, stroke);
    final point = Path()
      ..moveTo(10, 11.5)
      ..lineTo(9, 20)
      ..lineTo(13.5, 12.5)
      ..close();
    canvas.drawPath(point, stroke);
  }

  void _paintPopcorn(Canvas canvas, Paint stroke, Paint fill) {
    final box = Path()
      ..moveTo(6, 20)
      ..lineTo(5, 11)
      ..lineTo(19, 11)
      ..lineTo(18, 20)
      ..close();
    canvas.drawPath(box, stroke);
    canvas.drawLine(const Offset(9.5, 11), const Offset(9, 20), stroke);
    canvas.drawLine(const Offset(14.5, 11), const Offset(15, 20), stroke);
    final scallop = Path()
      ..moveTo(4.5, 11)
      ..quadraticBezierTo(6.5, 6, 8.5, 10.5)
      ..quadraticBezierTo(10.5, 5, 12.5, 10.5)
      ..quadraticBezierTo(14.5, 5, 16.5, 10.5)
      ..quadraticBezierTo(18.5, 6, 19.5, 11);
    canvas.drawPath(scallop, stroke);
  }

  void _paintPrincess(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(12, 15), 6, stroke);
    final crown = Path()
      ..moveTo(7, 9)
      ..lineTo(7, 5.5)
      ..lineTo(9.5, 7.5)
      ..lineTo(12, 3.5)
      ..lineTo(14.5, 7.5)
      ..lineTo(17, 5.5)
      ..lineTo(17, 9)
      ..close();
    canvas.drawPath(crown, stroke);
  }

  void _paintRainbow(Canvas canvas, Paint stroke, Paint fill) {
      const Offset center = Offset(12, 20);
      final List<double> radii = <double>[9, 6.5, 4.5];
      for (final double r in radii) {
        final Rect rect = Rect.fromCircle(center: center, radius: r);
        canvas.drawArc(rect, math.pi, math.pi, false, stroke);
      }
      canvas.drawLine(const Offset(9, 21), const Offset(15, 21), stroke);
    }

  void _paintRock(Canvas canvas, Paint stroke, Paint fill) {
      final Path path = Path();
      path.moveTo(5, 17);
      path.quadraticBezierTo(3, 14, 5, 11);
      path.quadraticBezierTo(6, 7, 10, 6);
      path.quadraticBezierTo(15, 5, 18, 8);
      path.quadraticBezierTo(21, 10, 19, 14);
      path.quadraticBezierTo(20, 18, 15, 19);
      path.quadraticBezierTo(9, 20, 5, 17);
      path.close();
      canvas.drawPath(path, stroke);
      canvas.drawLine(const Offset(8, 10), const Offset(13, 8), stroke);
    }

  void _paintRunning(Canvas canvas, Paint stroke, Paint fill) {
      // head (leaning forward)
      canvas.drawCircle(const Offset(15.5, 5), 1.8, stroke);
      // torso leaning
      canvas.drawLine(const Offset(15, 7), const Offset(11.5, 13), stroke);
      // front leg bent
      final frontLeg = Path()
        ..moveTo(11.5, 13)
        ..lineTo(9, 16)
        ..lineTo(11, 20);
      canvas.drawPath(frontLeg, stroke);
      // back leg extended
      final backLeg = Path()
        ..moveTo(11.5, 13)
        ..lineTo(16, 15)
        ..lineTo(19.5, 12);
      canvas.drawPath(backLeg, stroke);
      // front arm bent
      final frontArm = Path()
        ..moveTo(13, 8.5)
        ..lineTo(10, 9.5)
        ..lineTo(9, 7);
      canvas.drawPath(frontArm, stroke);
      // back arm bent
      final backArm = Path()
        ..moveTo(13.5, 9)
        ..lineTo(16.5, 10.5)
        ..lineTo(18, 8.5);
      canvas.drawPath(backArm, stroke);
    }

  void _paintShoe(Canvas canvas, Paint stroke, Paint fill) {
      final sneaker = Path()
        ..moveTo(4, 19)
        ..lineTo(19, 19)
        ..quadraticBezierTo(21, 19, 20.5, 16.5)
        ..quadraticBezierTo(20, 14.5, 17, 13)
        ..quadraticBezierTo(13, 11, 10, 8.5)
        ..quadraticBezierTo(8, 9.5, 6.5, 12)
        ..quadraticBezierTo(5, 14.5, 4, 19)
        ..close();
      canvas.drawPath(sneaker, stroke);
      // laces
      canvas.drawLine(const Offset(9.5, 11), const Offset(12, 9.5), stroke);
      canvas.drawLine(const Offset(11.5, 13), const Offset(14, 11.5), stroke);
    }

  void _paintShoppingBags(Canvas canvas, Paint stroke, Paint fill) {
    final bagBack = Path()
      ..moveTo(3, 11)
      ..lineTo(11, 11)
      ..lineTo(10, 20)
      ..lineTo(4, 20)
      ..close();
    canvas.drawPath(bagBack, stroke);
    canvas.drawArc(const Rect.fromLTWH(5, 6.5, 4, 6), -3.0, 2.7, false, stroke);

    final bagFront = Path()
      ..moveTo(9, 13)
      ..lineTo(17, 13)
      ..lineTo(16, 20)
      ..lineTo(10, 20)
      ..close();
    canvas.drawPath(bagFront, stroke);
    canvas.drawArc(const Rect.fromLTWH(11, 9, 4, 5.5), -3.0, 2.7, false, stroke);
  }

  void _paintShower(Canvas canvas, Paint stroke, Paint fill) {
      // showerhead dome
      final headRect = Rect.fromCircle(center: const Offset(12, 5.5), radius: 3.5);
      canvas.drawArc(headRect, math.pi, math.pi, false, stroke);
      // flat underside of head
      canvas.drawLine(const Offset(8.5, 5.5), const Offset(15.5, 5.5), stroke);
      // water lines
      canvas.drawLine(const Offset(9.5, 7), const Offset(9, 12), stroke);
      canvas.drawLine(const Offset(12, 7), const Offset(12, 13), stroke);
      canvas.drawLine(const Offset(14.5, 7), const Offset(15, 12), stroke);
      // droplets
      canvas.drawCircle(const Offset(9, 15), 0.7, fill);
      canvas.drawCircle(const Offset(15, 15), 0.7, fill);
    }

  void _paintSleepZzz(Canvas canvas, Paint stroke, Paint fill) {
    final bigZ = Path()
      ..moveTo(5, 14)
      ..lineTo(11, 14)
      ..lineTo(5, 20)
      ..lineTo(11, 20);
    canvas.drawPath(bigZ, stroke);
    final smallZ = Path()
      ..moveTo(13, 5)
      ..lineTo(17, 5)
      ..lineTo(13, 9)
      ..lineTo(17, 9);
    canvas.drawPath(smallZ, stroke);
    final tinyZ = Path()
      ..moveTo(17.5, 9.5)
      ..lineTo(20, 9.5)
      ..lineTo(17.5, 12)
      ..lineTo(20, 12);
    canvas.drawPath(tinyZ, stroke);
  }

  void _paintSleepyFace(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(12, 12), 8, stroke);
    final droopyEye = Path()
      ..moveTo(8, 11)
      ..quadraticBezierTo(9.5, 14, 11.5, 12);
    canvas.drawPath(droopyEye, stroke);
    final rightEye = Path()
      ..moveTo(13.5, 11)
      ..quadraticBezierTo(15, 12.5, 16.5, 11);
    canvas.drawPath(rightEye, stroke);
    final tear = Path()
      ..moveTo(8.5, 14.5)
      ..quadraticBezierTo(7.5, 16.5, 8.5, 17.5)
      ..quadraticBezierTo(9.5, 16.5, 8.5, 14.5);
    canvas.drawPath(tear, fill);
    final mouth = Path()
      ..moveTo(10.5, 16.5)
      ..quadraticBezierTo(12, 17.5, 13.5, 16.5);
    canvas.drawPath(mouth, stroke);
  }

  void _paintSparkles(Canvas canvas, Paint stroke, Paint fill) {
      void sparkle(Offset c, double r) {
        final Path path = Path();
        path.moveTo(c.dx, c.dy - r);
        path.quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy);
        path.quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r);
        path.quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy);
        path.quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r);
        path.close();
        canvas.drawPath(path, fill);
      }

      sparkle(const Offset(9, 9), 4);
      sparkle(const Offset(17, 15), 2.5);
      sparkle(const Offset(16, 7), 1.5);
    }

  void _paintSpeakingHead(Canvas canvas, Paint stroke, Paint fill) {
    final head = Path()
      ..moveTo(8, 5)
      ..quadraticBezierTo(14, 3.5, 16, 9)
      ..quadraticBezierTo(17, 11, 15, 12)
      ..quadraticBezierTo(14, 13, 13, 15)
      ..lineTo(9, 17)
      ..quadraticBezierTo(6, 15, 6, 10)
      ..quadraticBezierTo(6, 5, 8, 5)
      ..close();
    canvas.drawPath(head, stroke);

    canvas.drawArc(Rect.fromCircle(center: const Offset(17, 12), radius: 2), -0.9, 1.8, false, stroke);
    canvas.drawArc(Rect.fromCircle(center: const Offset(17, 12), radius: 4), -0.7, 1.4, false, stroke);
  }

  void _paintSpeechBubble(Canvas canvas, Paint stroke, Paint fill) {
    final bubble = RRect.fromRectAndRadius(
      const Rect.fromLTRB(4, 4, 20, 16),
      const Radius.circular(3),
    );
    canvas.drawRRect(bubble, stroke);

    final tail = Path()
      ..moveTo(18, 15.5)
      ..lineTo(20, 20)
      ..lineTo(14.5, 16);
    canvas.drawPath(tail, stroke);
  }

  void _paintStar(Canvas canvas, Paint stroke, Paint fill) {
      const double cx = 11;
      const double cy = 13;
      const double outerR = 7;
      const double innerR = 3;
      final Path path = Path();
      for (int i = 0; i < 5; i++) {
        final double outerAngle = -math.pi / 2 + i * 2 * math.pi / 5;
        final double innerAngle = outerAngle + math.pi / 5;
        final double ox = cx + outerR * math.cos(outerAngle);
        final double oy = cy + outerR * math.sin(outerAngle);
        if (i == 0) {
          path.moveTo(ox, oy);
        } else {
          path.lineTo(ox, oy);
        }
        final double ix = cx + innerR * math.cos(innerAngle);
        final double iy = cy + innerR * math.sin(innerAngle);
        path.lineTo(ix, iy);
      }
      path.close();
      canvas.drawPath(path, stroke);

      canvas.drawCircle(const Offset(19, 6), 0.8, fill);
      canvas.drawCircle(const Offset(20, 10), 0.5, fill);
    }

  void _paintStore(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawRect(const Rect.fromLTRB(4, 9, 20, 20), stroke);

    final awning = Path()
      ..moveTo(4, 9)
      ..lineTo(6, 6.5)
      ..lineTo(8, 9)
      ..lineTo(10, 6.5)
      ..lineTo(12, 9)
      ..lineTo(14, 6.5)
      ..lineTo(16, 9)
      ..lineTo(18, 6.5)
      ..lineTo(20, 9);
    canvas.drawPath(awning, stroke);

    canvas.drawRect(const Rect.fromLTRB(10, 14, 14, 20), stroke);
  }

  void _paintSun(Canvas canvas, Paint stroke, Paint fill) {
      const double cx = 12;
      const double cy = 12;
      canvas.drawCircle(const Offset(cx, cy), 4, stroke);
      for (int i = 0; i < 8; i++) {
        final double angle = i * math.pi / 4;
        final double x1 = cx + 5.5 * math.cos(angle);
        final double y1 = cy + 5.5 * math.sin(angle);
        final double x2 = cx + 8 * math.cos(angle);
        final double y2 = cy + 8 * math.sin(angle);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), stroke);
      }
    }

  void _paintSunrise(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawLine(const Offset(2, 16), const Offset(22, 16), stroke);
    final sun = Path()
      ..moveTo(6, 16)
      ..arcToPoint(const Offset(18, 16),
          radius: const Radius.circular(6), clockwise: true);
    canvas.drawPath(sun, stroke);
    canvas.drawLine(const Offset(12, 5), const Offset(12, 7.5), stroke);
    canvas.drawLine(const Offset(7.5, 7), const Offset(9, 9), stroke);
    canvas.drawLine(const Offset(16.5, 7), const Offset(15, 9), stroke);
  }

  void _paintSunriseMountain(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawLine(const Offset(2, 18), const Offset(22, 18), stroke);
    final sun = Path()
      ..moveTo(8, 18)
      ..arcToPoint(const Offset(16, 18),
          radius: const Radius.circular(4), clockwise: true);
    canvas.drawPath(sun, stroke);
    final leftMountain = Path()
      ..moveTo(2, 18)
      ..lineTo(8, 8)
      ..lineTo(13, 18);
    canvas.drawPath(leftMountain, stroke);
    final rightMountain = Path()
      ..moveTo(11, 18)
      ..lineTo(17, 6)
      ..lineTo(22, 18);
    canvas.drawPath(rightMountain, stroke);
  }

  void _paintTarget(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(12, 12), 8, stroke);
    canvas.drawCircle(const Offset(12, 12), 5, stroke);
    canvas.drawCircle(const Offset(12, 12), 2, fill);
  }

  void _paintTrophy(Canvas canvas, Paint stroke, Paint fill) {
    final cup = Path()
      ..moveTo(7, 5)
      ..lineTo(17, 5)
      ..lineTo(16, 12)
      ..quadraticBezierTo(12, 16, 8, 12)
      ..close();
    canvas.drawPath(cup, stroke);
    final leftHandle = Path()
      ..moveTo(7, 6)
      ..quadraticBezierTo(2, 6, 3, 10)
      ..quadraticBezierTo(3.5, 12.5, 7.5, 11.5);
    canvas.drawPath(leftHandle, stroke);
    final rightHandle = Path()
      ..moveTo(17, 6)
      ..quadraticBezierTo(22, 6, 21, 10)
      ..quadraticBezierTo(20.5, 12.5, 16.5, 11.5);
    canvas.drawPath(rightHandle, stroke);
    canvas.drawLine(const Offset(12, 16), const Offset(12, 18.5), stroke);
    canvas.drawLine(const Offset(8.5, 20.5), const Offset(15.5, 20.5), stroke);
    canvas.drawLine(const Offset(9.5, 18.5), const Offset(8.5, 20.5), stroke);
    canvas.drawLine(const Offset(14.5, 18.5), const Offset(15.5, 20.5), stroke);
  }

  void _paintTv(Canvas canvas, Paint stroke, Paint fill) {
    final screen = RRect.fromRectAndRadius(
      const Rect.fromLTRB(3, 5, 21, 16),
      const Radius.circular(2),
    );
    canvas.drawRRect(screen, stroke);
    canvas.drawLine(const Offset(9, 16), const Offset(6, 20), stroke);
    canvas.drawLine(const Offset(15, 16), const Offset(18, 20), stroke);
  }

  void _paintWalk(Canvas canvas, Paint stroke, Paint fill) {
      // head
      canvas.drawCircle(const Offset(13, 5), 2, stroke);
      // torso
      canvas.drawLine(const Offset(12.5, 7), const Offset(11, 14), stroke);
      // front leg
      canvas.drawLine(const Offset(11, 14), const Offset(15, 20), stroke);
      // back leg
      canvas.drawLine(const Offset(11, 14), const Offset(8, 19), stroke);
      // front arm
      canvas.drawLine(const Offset(11.5, 9), const Offset(15, 11), stroke);
      // back arm
      canvas.drawLine(const Offset(11.5, 9), const Offset(9, 7), stroke);
    }

  void _paintWeightlifting(Canvas canvas, Paint stroke, Paint fill) {
      // bar
      canvas.drawLine(const Offset(5, 12), const Offset(19, 12), stroke);
      // plates
      canvas.drawCircle(const Offset(4.5, 12), 3, stroke);
      canvas.drawCircle(const Offset(19.5, 12), 3, stroke);
      // collars
      canvas.drawLine(const Offset(7.5, 9.5), const Offset(7.5, 14.5), stroke);
      canvas.drawLine(const Offset(16.5, 9.5), const Offset(16.5, 14.5), stroke);
      // grip mark
      canvas.drawCircle(const Offset(12, 12), 0.6, fill);
    }

}
