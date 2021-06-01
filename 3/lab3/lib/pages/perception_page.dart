import 'package:flutter/material.dart';
import 'package:lab3/services/perception.dart';

class PerceptionPage extends StatefulWidget {
  PerceptionPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return __PerceptionPageState();
  }
}

class __PerceptionPageState extends State<PerceptionPage> {
  double w1;
  double w2;
  int iterations;
  double time;

  final iterationsTextController = TextEditingController();
  final maxTimeTextController = TextEditingController();
  final learningRateTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    iterationsTextController.dispose();
    maxTimeTextController.dispose();
    learningRateTextController.dispose();
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
          child: Text('Perception', style: TextStyle(fontSize: 20)),
        ),
        Container(
          width: 300,
          child: TextField(
            controller: iterationsTextController,
            decoration: const InputDecoration(
              hintText: 'Enter max interations',
              hintStyle: TextStyle(color: Colors.black38),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue,
            ),
          ),
        ),
        Container(
          width: 300,
          child: TextField(
            controller: maxTimeTextController,
            decoration: const InputDecoration(
              hintText: 'Enter max time',
              hintStyle: TextStyle(color: Colors.black38),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.lightBlue,
            ),
          ),
        ),
        Container(
          width: 300,
          child: TextField(
            controller: learningRateTextController,
            decoration: const InputDecoration(
              hintText: 'Enter learning rate',
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
              var learningRate = double.parse(learningRateTextController.text);
              var maxTime = double.parse(maxTimeTextController.text);
              var maxIterations = double.parse(iterationsTextController.text);

              var result = new Perception(4, learningRate).learn([
                [0, 6],
                [1, 5],
                [3, 3],
                [2, 4]
              ], maxIterations, maxTime);

              setState(() {
                w1 = result[0];
                w2 = result[1];
                time = result[2];
                iterations = result[3];
              });
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
                  Text('w1: ${this.w1 ?? '-'}', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child:
                  Text('w2: ${this.w2 ?? '-'}', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('time: ${this.time ?? '-'}',
                  style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('iterations: ${this.iterations ?? '-'}',
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ]),
    );
  }
}
