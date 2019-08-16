import 'package:flutter/material.dart';

void main() => runApp(MyApp());

ValueNotifier<double> valueListener = ValueNotifier(.0);


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double txtPos = -4.3;

  void setTxtPos(double num){
    setState(() {
      txtPos = num;   
    });
  }

  @override
  void initState() {
    ValueNotifier<double> v = valueListener;

    v.addListener(() {

      if(v.value * 4.0 > 1.3){
        setState(() {
          txtPos = -4.3 + (v.value * 4.0);
        });
      }
     

      print(txtPos);
      
    });
    super.initState();
  }

  @override
  void dispose() {
    valueListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100.0)
            ),
            child: Stack(
              children: <Widget>[
                Slider(setTxtPos),
                Align(
                  alignment: Alignment(txtPos, 0),
                  child: txtPos < -1.1 ? Text('') :
                  Text(
                    'CONFIRM', 
                    style: TextStyle(
                      color: Colors.lightBlueAccent, fontSize: 24, fontWeight: FontWeight.w900
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Slider extends StatefulWidget {
  final Function setTxtPos;
  Slider(this.setTxtPos);
  @override
  SliderState createState() => SliderState();
}

class SliderState extends State<Slider> {
  
  @override
  void initState() {
    valueListener.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    valueListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(
        builder: (context) {
          final handle = GestureDetector(
            onHorizontalDragUpdate: (dtls) {
              // print('dx ${dtls.delta.dx}');
              valueListener.value = (valueListener.value +
                      dtls.delta.dx / context.size.width).clamp(.0, 1.0);
            },
            onHorizontalDragEnd: (_) {
              // print('dragEnd ${valueListener.value}');
              if(valueListener.value == 1){
                widget.setTxtPos(-4.0);
    
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
              widget.setTxtPos(-4.0);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(100.0)
              ),
              height: 60.0,
              width: 60.0,
              child: Center(
                child: Icon(Icons.arrow_forward_ios, color: Colors.white)
              ),
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