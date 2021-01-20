
import 'package:flutter/material.dart';

/// Widget that builds a list of dot indicators
class DotsIndicator extends StatelessWidget {
  final int size;
  final int selected;

  DotsIndicator({
    Key key,
    this.size = 1,
    this.selected = 0
  }): assert(size > 0),
    assert(selected >= 0),
    assert(selected < size),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildIndicators(),
      ),
    );
  }

  /// Build a list of indicators
  List<Widget> _buildIndicators() {
    List<Widget> result = [];
    for (int i = 0; i < size; i++) {
      result.add(i == selected? _buildIndicator(true): _buildIndicator(false));
    }
    return result;
  }

  /// Returns the single dot in the indicator
  Widget _buildIndicator(bool isActive) => AnimatedContainer(
    duration: Duration(milliseconds: 200),
    margin: const EdgeInsets.symmetric(horizontal: 6.0),
    height: 8.0,
    width: isActive? 30.0: 8.0,
    decoration: BoxDecoration(
      color: isActive? Colors.white: Colors.white38,
      borderRadius: BorderRadius.all(Radius.circular(20))
    ),
  );
}
