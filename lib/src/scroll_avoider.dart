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

  @override
  void didChangeMetrics() {
    if (widget.fn.hasFocus) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        checkScroll();
      });
    }
  }

  void checkScroll() {
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

    // if keyboardTop less than widgetBottom then keyboardTop higher up and overlapping

    if (keyboardTop < widgetBottom) {
      var overlap = widgetBottom - keyboardTop;
      // TODO fix this as it doesn't work properly if already scrolled down
      var scrollCtrlr = widget.sc;
      var currentPosition = scrollCtrlr.offset;
      var scrollAmount = currentPosition + overlap + widget.keyboardOffset;

      scrollCtrlr.animateTo(scrollAmount,
          duration: widget.duration, curve: widget.animationCurve);
      widget.fn.addListener(() => unfocusListener(currentPosition));
    }
  }

  void unfocusListener(double originalPosition) {
    // if still active, they don't move it as if use selects textfield above the
    // kb then it will suddenly drop down under the kb
    // only check after the keyboard has been retracted
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200)).then((_) {
        if (!widget.fn.hasFocus && !Keyboard.of(context).isActive) {
          // animating to zero moves it back to zero offset from
          widget.sc.animateTo(originalPosition,
              duration: widget.duration, curve: widget.animationCurve);
          widget.fn.removeListener(() => unfocusListener(originalPosition));
        }
      });
    });
  }
}
