import 'package:flutter/material.dart';

// TODO just add it as a keyboard aware textfield that can be set with its own properties
// can prob just extend textfield

class KeyboardAvoider extends StatefulWidget {
  const KeyboardAvoider(
      {Key? key,
      required Widget child,
      required ScrollController sc,
      required FocusNode fn})
      : this.child = child,
        this.sc = sc,
        this.fn = fn,
        super(key: key);

  final Widget child;
  final ScrollController sc;
  final FocusNode fn;

  @override
  _KeyboardAvoiderState createState() => _KeyboardAvoiderState();
}

class _KeyboardAvoiderState extends State<KeyboardAvoider>
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
  Widget build(BuildContext context) => widget.child;

  @override
  void didChangeMetrics() {
    if (widget.fn.hasFocus) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        checkResize();
      });
    }
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

    // screenInsets.bottom is the distance from bottom of screen to top of keyboard inset
    // translate to y coord:
    final keyboardTop = screenSize.height - screenInsets.bottom;

    // if keyboardTop less than widgetBottom then keyboardTop higher up and overlapping

    if (keyboardTop < widgetBottom) {
      var overlap = widgetBottom - keyboardTop;
      // TODO fix this as it doesn't work properly if already scrolled down
      var scrollCtrlr = widget.sc;
      var currentPosition = scrollCtrlr.offset;
      var scrollAmount = currentPosition + overlap;
      scrollCtrlr.animateTo(scrollAmount,
          duration: Duration(milliseconds: 100), curve: Curves.decelerate);
      widget.fn.addListener(() => unfocusListener(currentPosition));
    }
  }

  void unfocusListener(double originalPosition) {
    if (!widget.fn.hasFocus) {
      // animating to zero moves it back to zero offset from
      widget.sc.animateTo(originalPosition,
          duration: Duration(milliseconds: 100), curve: Curves.decelerate);
      widget.fn.removeListener(() => unfocusListener(originalPosition));
    }
  }
}
