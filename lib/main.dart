import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Slider(),
        ),
      ),
    );
  }
}

class Slider extends StatefulWidget {
  final ValueChanged<double> valueChanged;

  Slider({this.valueChanged});

  @override
  SliderState createState() {
    return SliderState();
  }
}

class SliderState extends State<Slider> {
  ValueNotifier<double> valueListener = ValueNotifier(.0);

  @override
  void initState() {
    valueListener.addListener(notifyParent);
    super.initState();
  }

  void notifyParent() {
    if (widget.valueChanged != null) {
      widget.valueChanged(valueListener.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(100.0)
      ),
      height: 50.0,
      width: 150.0,
      child: Builder(
        builder: (context) {
          final handle = GestureDetector(
            onHorizontalDragUpdate: (details) {
              // print(details);
              valueListener.value = (valueListener.value +
                      details.delta.dx / context.size.width)
                  .clamp(.0, 1.0);
            },
            onHorizontalDragEnd: (_) {
              if(valueListener.value == 1){
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Center(child: Text('yay')),
                    );
                  },
                );
              }
              // print(valueListener.value);
              valueListener.value = 0.0;
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(100.0)
              ),
              height: 50.0,
              width: 60.0,
            ),
          );

          return AnimatedBuilder(
            animation: valueListener,
            builder: (context, child) {
              return Align(
                alignment: Alignment(valueListener.value * 2 - 1, .5),
                child: child,
              );
            },
            child: handle,
          );
        },
      ),
    );
  }
}