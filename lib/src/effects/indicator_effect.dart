import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/src/painters/indicator_painter.dart';

abstract class IndicatorEffect {
  const IndicatorEffect();

  /// Builds a new painter every time the page offset changes
  IndicatorPainter buildPainter(int count, double offset);

  /// Calculates the size of canvas based on
  /// dots count, size and spacing
  ///
  /// Other effects can override this function
  /// to calculate their own size
  Size calculateSize(int count);

  /// Returns the index of the section that contains [dx].
  ///
  /// Sections or hit-targets are calculated differently
  /// in some effects
  int hitTestDots(double dx, int count, double current);
}

abstract class BasicIndicatorEffect extends IndicatorEffect {
  /// Singe dot width
  final double dotWidth;

  /// Singe dot height
  final double dotHeight;

  /// The horizontal space between dots
  final double spacing;

  /// Single dot radius
  final double radius;

  /// Inactive dots color or all dots in some effects
  final Color dotColor;

  /// The active dot color
  final Color activeDotColor;

  /// Inactive dots paint style (fill|stroke) defaults to fill.
  final PaintingStyle paintStyle;

  /// This is ignored if [paintStyle] is PaintStyle.fill
  final double strokeWidth;

  final LinearGradient? linearGradient;

  const BasicIndicatorEffect({
    required this.strokeWidth,
    required this.dotWidth,
    required this.dotHeight,
    required this.spacing,
    required this.radius,
    required this.dotColor,
    required this.paintStyle,
    this.linearGradient,
    required this.activeDotColor,
  }) : assert(dotWidth >= 0 &&
            dotHeight >= 0 &&
            spacing >= 0 &&
            strokeWidth >= 0);

  @override
  Size calculateSize(int count) {
    return Size(dotWidth * count + (spacing * (count - 1)), dotHeight);
  }

  @override
  int hitTestDots(double dx, int count, double current) {
    var offset = -spacing / 2;
    for (var index = 0; index < count; index++) {
      if (dx <= (offset += dotWidth + spacing)) {
        return index;
      }
    }
    return -1;
  }
}
