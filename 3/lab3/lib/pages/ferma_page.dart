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

  Widget _buildPopupDialog(BuildContext context, Duration time) {
    return new AlertDialog(
      title: const Text('Popup'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${time}"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
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
                  
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopupDialog(context, result[2]),
                  );
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
