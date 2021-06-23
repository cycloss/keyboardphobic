import 'package:flutter/material.dart';

/// A simple utility that provides information about the soft keyboard.
class Keyboard {
  final BuildContext _context;

  bool get isActive => height > 0;

  /// The distance from the bottom of the screen to the top of the keyboard
  double get height {
    return MediaQuery.of(_context).viewInsets.bottom;
  }

  void dismiss() => FocusScope.of(_context).unfocus();

  Keyboard._(this._context);

  static Keyboard of(BuildContext context) {
    return Keyboard._(context);
  }
}
