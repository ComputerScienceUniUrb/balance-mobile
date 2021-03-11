
import 'package:balance_app/bloc/main/home/states/countdown_state.dart';
import 'package:balance_app/screens/res/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

/// Enum class representing the direction
/// (mode) in which the CircularCounter
/// will fill
///
/// - normal, fill from left to right
/// - reverse, fill from right to left
enum FillMode { normal, reverse }

/// Widget containing the logic for the circular counter
class CircularCounter extends StatefulWidget {
  final CountdownState state;

  CircularCounter({
    Key key,
    this.state,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CircularCounterState();
  }
}

class _CircularCounterState extends State<CircularCounter> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _controller.duration = _duration;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FillMode get _fillMode => widget.state is CountdownMeasureState
    ? FillMode.normal
    : FillMode.reverse;

  Duration get _duration => Duration(
    milliseconds: widget.state is CountdownMeasureState
      ? 30000
      : 2000
  );

  String get _timeString {
    Duration dT = _fillMode == FillMode.reverse
      ? (_controller.duration * (1-_controller.value))
      : Duration(seconds: 0) + _controller.duration * _controller.value;
    return "${(dT.inSeconds % 60).toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    bool isLightTheme = themeData.brightness == Brightness.light;

    Color textColor = isLightTheme
      ? Colors.black
      : Colors.white;

    return Stack(
      alignment: Alignment.center,
      children: [
        FittedBox(
          child: SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: ArcPainter(
                animation: _controller,
                bgColor: themeData.scaffoldBackgroundColor,
                color: BColors.colorPrimary,
                fillMode: _fillMode,
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Column(
            children: [
              Text(
                widget.state is CountdownMeasureState
                  ? 'measuring_txt'.tr()
                  : 'get_ready_txt'.tr(),
                style: TextStyle(
                  color: BColors.textColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: _timeString,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                  ),
                  children: [
                    TextSpan(
                      text: " s",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      )
                    )
                  ]
                )
              ),
            ],
          )
        )
      ]
    );
  }
}

/// Painter class for the countdown arc
class ArcPainter extends CustomPainter {
  /// Start position of the arc in radians
  static const START_RAD = 2.35619;
  /// Length of the arc in radians
  static const SWIPE_RAD = 4.71239;

  /// Animation object used to time the arc filling
  final Animation<double> animation;
  /// Color of the background
  final Color bgColor;
  /// Color of the arc
  final Color color;
  /// Represent the chosen fill mode
  final FillMode fillMode;
  
  // Paint object for the timer
  final _paint = Paint()
    ..strokeWidth = 10.0
    .. strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  ArcPainter({
    this.animation,
    this.bgColor,
    this.color,
    this.fillMode = FillMode.normal,
  }): super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = bgColor;

    final radius = Math.min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw the background arc
    canvas.drawArc(rect, START_RAD, SWIPE_RAD, false, _paint);
    // Compute the current sweep angle
    double progress = (this.fillMode == FillMode.normal)
      ? SWIPE_RAD * animation.value
      : SWIPE_RAD - (SWIPE_RAD * animation.value);
    // Draw the progress arc
    _paint.color = color;
    canvas.drawArc(rect, START_RAD, progress, false, _paint);
  }

  @override
  bool shouldRepaint(ArcPainter old) {
    return animation.value != old.animation.value ||
      color != old.color ||
      bgColor != old.bgColor ||
      fillMode != old.fillMode;
  }
}