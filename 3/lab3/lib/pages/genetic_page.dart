import 'package:flutter/material.dart';
import 'package:lab3/services/genetics.dart';

class GeneticPage extends StatefulWidget {
  GeneticPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __GeneticPageState();
  }
}

class __GeneticPageState extends State<GeneticPage> {
  double x1;
  double x2;
  double x3;
  double x4;
  int time;

  final aController = TextEditingController();
  final bController = TextEditingController();
  final cController = TextEditingController();
  final dController = TextEditingController();
  final yController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    aController.dispose();
    bController.dispose();
    cController.dispose();
    dController.dispose();
    yController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text('Genetics', style: TextStyle(fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child:
              Text('ax1 + bx2 + cx3 + dx4 = y', style: TextStyle(fontSize: 20)),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 4.0),
          width: 100,
          child: TextField(
            controller: aController,
            decoration: const InputDecoration(
              hintText: 'a',
              hintStyle: TextStyle(color: Colors.black38),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: TextField(
            controller: bController,
            decoration: const InputDecoration(
              hintText: 'b',
              hintStyle: TextStyle(color: Colors.black38),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: TextField(
            controller: cController,
            decoration: const InputDecoration(
              hintText: 'c',
              hintStyle: TextStyle(color: Colors.black38),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: TextField(
            controller: dController,
            decoration: const InputDecoration(
              hintText: 'd',
              hintStyle: TextStyle(color: Colors.black38),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: TextField(
            controller: yController,
            decoration: const InputDecoration(
              hintText: 'y',
              hintStyle: TextStyle(color: Colors.black38),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              var a = int.parse(aController.text);
              var b = int.parse(bController.text);
              var c = int.parse(cController.text);
              var d = int.parse(dController.text);
              var y = int.parse(yController.text);

              var startDate = DateTime.now().microsecondsSinceEpoch;
              var result = new Genetics().diophantineEquation(
                  equation: [a, b, c, d, y], populationSize: 10);
              print(result.length);
              if (result.length == 4) {
                setState(() {
                  x1 = result[0].toDouble();
                  x2 = result[1].toDouble();
                  x3 = result[2].toDouble();
                  x4 = result[3].toDouble();
                  time = DateTime.now().microsecondsSinceEpoch - startDate;
                });
              }
            },
            child: const Text('Submit'),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child:
                  Text('x1: ${this.x1 ?? '-'}', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child:
                  Text('x2: ${this.x2 ?? '-'}', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child:
                  Text('x3: ${this.x3 ?? '-'}', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child:
                  Text('x4: ${this.x4 ?? '-'}', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('time: ${this.time ?? '-'}',
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ]),
    );
  }
}
