
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// [MatchFinder] that finds all the [Material]s with
/// the given [color]
class MaterialHasColor extends MatchFinder {
  MaterialHasColor(
    this.color,
    { bool skipOffstage = true }
    ): super(skipOffstage: skipOffstage);

  final Color color;

  @override
  String get description => 'Material{color: "$color"}';

  @override
  bool matches(Element candidate) {
    if (candidate.widget is Material) {
      final Material materialWidget = candidate.widget;
      return materialWidget.color == color;
    }
    return false;
  }
}

/// [MatchFinder] that finds all the [Container]s with
/// the given [color]
class ContainerHasColor extends MatchFinder {
  ContainerHasColor(
    this.color,
    { bool skipOffstage = true }
    ): super(skipOffstage: skipOffstage);

  final Color color;

  @override
  String get description => 'Container{color: "$color"}';

  @override
  bool matches(Element candidate) {
    if (candidate.widget is Container) {
      final Container container = candidate.widget;
      if (container.decoration is BoxDecoration) {
        final BoxDecoration boxDecoration = container.decoration;
        return boxDecoration.color == color;
      }
    }
    return false;
  }
}