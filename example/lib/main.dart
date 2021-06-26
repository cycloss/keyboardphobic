import 'package:flutter/material.dart';
import 'package:keyboardphobic/keyboard_avoider.dart';

void main() {
  var app = MaterialApp(
    home: Example(),
  );
  runApp(app);
}

class Example extends StatelessWidget {
  Example({Key? key}) : super(key: key);

  final fn1 = FocusNode();
  final fn2 = FocusNode();
  final scrollController = ScrollController();
  final fn3 = FocusNode();
  final fn4 = FocusNode();

  final box = SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: KeyboardDismisser(
        child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Padding avoid',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    box,
                    Text(
                      'Swipe down or tap outside text field to exit',
                    ),
                    box,
                    SmartPadTextField(
                      keyboardOffset: 10,
                      focusNode: fn1,
                      duration: Duration(milliseconds: 300),
                    ),
                    box,
                    SmartPadFormField(
                      keyboardOffset: 10,
                      focusNode: fn2,
                      duration: Duration(milliseconds: 300),
                      validator: (text) => 'validator error text',
                      autovalidateMode: AutovalidateMode.always,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: 2,
                color: Colors.black38,
              ),
              Expanded(
                child: ListView(
                  // physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  children: [
                    ...List.generate(25, (_) => box),
                    Text(
                      'Scroll avoid',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    box,
                    Text(
                      'Swipe down or tap outside text field to exit',
                    ),
                    box,
                    SmartScrollTextField(
                      enclosingScrollController: scrollController,
                      keyboardOffset: 10,
                      focusNode: fn3,
                      duration: Duration(milliseconds: 300),
                    ),
                    box,
                    SmartScrollFormField(
                      enclosingScrollController: scrollController,
                      keyboardOffset: 10,
                      focusNode: fn4,
                      duration: Duration(milliseconds: 300),
                      validator: (text) => 'validator error text',
                      autovalidateMode: AutovalidateMode.always,
                    ),
                    ...List.generate(25, (_) => box),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
