import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/src/effects/worm_effect.dart';

import 'indicator_painter.dart';

class WormPainter extends BasicIndicatorPainter {
  final WormEffect effect;

  WormPainter({
    required this.effect,
    required int count,
    required double offset,
  }) : super(offset, count, effect);

  @override
  void paint(Canvas canvas, Size size) {
    // paint still dots
    paintStillDots(canvas, size);

    var rect = Offset.zero & size;
    var activeDotPaint = effect.linearGradient != null ? (Paint()..shader = effect.linearGradient!.createShader(rect)):Paint()..color = effect.activeDotColor;
    final dotOffset = (offset - offset.toInt());

    // handle dot travel from end to start (for infinite pager support)
    if (offset > count - 1) {
      final startDot = calcPortalTravel(size, effect.dotWidth / 2, dotOffset);

      canvas.drawRRect(startDot, activeDotPaint);

      final endDot = calcPortalTravel(
        size,
        ((count - 1) * distance) + (effect.dotWidth / 2),
        1 - dotOffset,
      );
      activeDotPaint = effect.linearGradient != null ? (Paint()..shader = effect.linearGradient!.createShader(endDot.outerRect)):Paint()..color = effect.activeDotColor;

      canvas.drawRRect(endDot, activeDotPaint);
      return;
    }

    final wormOffset = dotOffset * 2;
    final xPos = (offset.floor() * distance);
    final yPos = size.height / 2;
    var head = xPos;
    var tail = xPos + effect.dotWidth + (wormOffset * distance);
    var halfHeight = effect.dotHeight / 2;
    var thinWorm = effect.type == WormType.thin;
    var dotHeight = thinWorm
        ? halfHeight + (halfHeight * (1 - wormOffset))
        : effect.dotHeight;

    if (wormOffset > 1) {
      tail = xPos + effect.dotWidth + (1 * distance);
      head = xPos + distance * (wormOffset - 1);
      if (thinWorm) {
        dotHeight = halfHeight + (halfHeight * (wormOffset - 1));
      }
    }
    final worm = RRect.fromLTRBR(
      head,
      yPos - dotHeight / 2,
      tail,
      yPos + dotHeight / 2,
      dotRadius,
    );

    activeDotPaint = effect.linearGradient != null ? (Paint()..shader = effect.linearGradient!.createShader(worm.outerRect)):Paint()..color = effect.activeDotColor;

    canvas.drawRRect(worm, activeDotPaint);
  }
}
