import 'package:flutter/material.dart';

class KeyboardDismisser extends StatelessWidget {
  KeyboardDismisser(
      {Key? key, required Widget child, Color debugColor = Colors.transparent})
      : _child = child,
        _debugColor = debugColor,
        super(key: key);

  final Widget _child;
  final Color _debugColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _debugColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: _child,
        onTap: () => FocusScope.of(context).unfocus(),
        onVerticalDragUpdate: (drag) {
          var dist = drag.delta.distanceSquared;
          if (dist > 800 && drag.delta.direction > 0) {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
