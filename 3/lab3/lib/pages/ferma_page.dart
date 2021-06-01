import 'package:flutter/material.dart';
import 'package:lab3/services/fermatFactor.dart';

class FermaPage extends StatefulWidget {
  FermaPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __FermaPageState();
  }
}

class __FermaPageState extends State<FermaPage> {
  int a;
  int b;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Fermat Factors', style: TextStyle(fontSize: 20)),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: myController,
                decoration: const InputDecoration(
                  hintText: 'Enter your number',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.lightBlue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('${a ?? 'x'} * ${b ?? 'x'}',
                  style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  var result = new FermatFactor(double.parse(myController.text))
                      .calculate();

                  setState(() {
                    a = result[0][0].toInt();
                    b = result[0][1].toInt();
                  });
                },
                child: const Text('Submit'),
              ),
            ),
          ]),
    );
  }
}
