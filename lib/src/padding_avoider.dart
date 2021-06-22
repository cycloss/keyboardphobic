library keyboardphobic;

import 'package:flutter/material.dart';

import 'keyboard_utility.dart';

class PaddingAvoider extends StatefulWidget {
  const PaddingAvoider({Key? key, required Widget child, required FocusNode fn})
      : this._child = child,
        this._fn = fn,
        super(key: key);

  final Widget _child;
  final FocusNode _fn;

  @override
  _PaddingAvoiderState createState() => _PaddingAvoiderState();
}

class _PaddingAvoiderState extends State<PaddingAvoider>
    with WidgetsBindingObserver {
  // widgets binding observer has didChangeMetrics which is called when viewport resizes

  @override
  void initState() {
    super.initState();
    // allows for watching for changes in the widgets like did change metrics
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  double paddingAmount = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        padding: EdgeInsets.fromLTRB(0, 0, 0, paddingAmount),
        duration: Duration(milliseconds: 100),
        child: widget._child);
  }

  @override
  void didChangeMetrics() {
    print('changing metrics');
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget._fn.hasFocus) {
        checkResize();
      } else {
        // if still active, they don't move it as if use selects textfield above the
        // kb then it will suddenly drop down under the kb
        if (!Keyboard.of(context).isActive) {
          setState(() {
            paddingAmount = 0;
          });
        }
      }
    });
  }

  void checkResize() {
    // `State` can get its context unlike a Stateless widget
    var renderBox = context.findRenderObject() as RenderBox;

    // top left of widget from top left of screen
    var offset = renderBox.localToGlobal(Offset.zero);
    // add box's height to offset to get bottom of widget
    var widgetBottom = offset.dy + renderBox.size.height;

    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenInsets = mediaQuery.viewInsets;
    print('checking');
    // screenInsets.bottom is the distance from bottom of screen to top of keyboard inset
    // translate to y coord:
    final keyboardTop = screenSize.height - screenInsets.bottom;

    // if keyboardTop less than widgetBottom then keyboardTop higher up and overlapping

    if (keyboardTop < widgetBottom) {
      var overlap = widgetBottom - keyboardTop;

      setState(() {
        paddingAmount = overlap;
      });

      // widget.fn.addListener(unfocusListener);
    }
  }

  // void unfocusListener() {
  //   if (!widget.fn.hasFocus) {
  //     // animating to zero moves it back to zero offset from
  //     setState(() {
  //       paddingAmount = 0;
  //     });
  //     widget.fn.removeListener(() => unfocusListener);
  //   }
  // }
}
