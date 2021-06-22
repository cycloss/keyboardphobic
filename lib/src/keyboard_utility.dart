import 'package:flutter/material.dart';

/// A simple utility that can get some onscreen keyboard information
class Keyboard {
  final BuildContext _context;

  bool get isActive => keyboardSize > 0;

  /// The distance from the bottom of the screen to the top of the keyboard
  double get keyboardSize {
    return MediaQuery.of(_context).viewInsets.bottom;
  }

  Keyboard._(this._context);

  static Keyboard of(BuildContext context) {
    return Keyboard._(context);
  }
}
