import 'package:flutter/material.dart';

class KeyboardDismisser extends StatelessWidget {
  KeyboardDismisser(
      {Key? key, required Widget child, Color debugColor = Colors.transparent})
      : _child = child,
        _debugColor = debugColor,
        super(key: key);

  final Widget _child;
  final FocusNode _fn = FocusNode();
  final Color _debugColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _debugColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: _child,
        onTap: () {
          print('dismissing');
          FocusScope.of(context).requestFocus(_fn);
        },
      ),
    );
  }
}
