import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// TODO this class isn't used yet
class ContainerByColorFinder extends MatchFinder {
  ContainerByColorFinder(this.color, {bool skipOffstage = true})
      : super(skipOffstage: skipOffstage);

  final Color color;

  @override
  String get description => 'Container{color: "$color"}';

  @override
  bool matches(Element candidate) {
    if (candidate.widget is Container) {
      final Container containerWidget = candidate.widget as Container;
      if (containerWidget.decoration is BoxDecoration) {
        final BoxDecoration decoration =
            containerWidget.decoration as BoxDecoration;
        return decoration.color == color;
      }
      return false;
    }
    return false;
  }
}
