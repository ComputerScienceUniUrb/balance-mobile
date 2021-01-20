
import 'package:flutter/material.dart';
import 'package:balance_app/widgets/measure_countdown.dart';
import 'package:focus_detector/focus_detector.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: MeasureCountdown(),
    );
  }
}
