import 'package:flutter/material.dart';

import '../keyboard_avoider.dart';

// TODO add keyboard offset and rename keyboard padding to keyboardOffset
// TODO add duration param
// TODO add animation curve param, also add to everything else
class ScrollAvoider extends StatefulWidget {
  const ScrollAvoider(
      {Key? key,
      required Widget child,
      double? keyboardOffset,
      Duration? duration,
      Curve? animationCurve,
      required ScrollController scrollController,
      required FocusNode focusNode})
      : this.child = child,
        this.keyboardOffset = keyboardOffset ?? 0,
        this.duration = duration ?? const Duration(milliseconds: 300),
        this.animationCurve = animationCurve ?? Curves.decelerate,
        this.sc = scrollController,
        this.fn = focusNode,
        super(key: key);

  final Widget child;
  final double keyboardOffset;
  final Duration duration;
  final Curve animationCurve;
  final ScrollController sc;
  final FocusNode fn;

  @override
  _ScrollAvoiderState createState() => _ScrollAvoiderState();
}

class _ScrollAvoiderState extends State<ScrollAvoider>
    with WidgetsBindingObserver {
  // widgets binding observer has didChangeMetrics which is called when viewport resizes

  @override
  void initState() {
    super.initState();
    // allows for watching for changes in the widgets
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  double? returnPos;

  @override
  void didChangeMetrics() {
    var active = Keyboard.of(context).isActive;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.fn.hasFocus) {
        // keyboard not active until post frame callback so if not active then was first to move
        checkScroll(active);
      } else if (returnPos != null && Keyboard.of(context).isNotActive) {
        widget.sc.animateTo(returnPos!,
            duration: widget.duration, curve: widget.animationCurve);
        returnPos = null;
      }
    });
  }

  void checkScroll(bool kbAlreadyActive) {
    // `State` can get its context unlike a Stateless widget
    var renderBox = context.findRenderObject() as RenderBox;
    // top left of widget from top left of screen
    var offset = renderBox.localToGlobal(Offset.zero);
    // add box's height to offset to get bottom of widget
    var widgetBottom = offset.dy + renderBox.size.height;

    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenInsets = mediaQuery.viewInsets;

    // screenInsets.bottom is the distance from bottom of screen to top of keyboard inset
    // translate to y coord:
    final keyboardTop = screenSize.height - screenInsets.bottom;

    var overlap = widgetBottom - keyboardTop;
    var scrollCtrlr = widget.sc;
    var currentPosition = scrollCtrlr.offset;
    // if wasn't active then was first to come into focus
    // Always set this as other text fields may push the first higher
    if (!kbAlreadyActive) {
      returnPos = currentPosition;
    }
    var scrollAmount = currentPosition + overlap + widget.keyboardOffset;
    // if keyboardTop less than widgetBottom (then keyboardTop higher up and overlapping)
    if (keyboardTop < widgetBottom) {
      scrollCtrlr.animateTo(scrollAmount,
          duration: widget.duration, curve: widget.animationCurve);
    }
  }
}
