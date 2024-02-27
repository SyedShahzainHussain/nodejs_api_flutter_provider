import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height *1;
  double get width => MediaQuery.sizeOf(this).width *1;
}
