import 'package:flutter/material.dart';
import 'package:lab3/pages/ferma_page.dart';
import 'package:lab3/pages/genetic_page.dart';
import 'package:lab3/theme/colors.dart';
import 'package:lab3/pages/perception_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      backgroundColor: black,
      body: getBody(),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      FermaPage(),
      PerceptionPage(),
      GeneticPage(),
    ];
    return IndexedStack(
      index: page,
      children: pages,
    );
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: appBarColor,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Labs 3.1;  3.2;  3.3",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBottomNavigationBar() {
    List bottomItems = [
      "Fermat's Factors",
      "Perception",
      "Genetic",
    ];
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(color: appFooterColor),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomItems.length, (index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    page = index;
                  });
                },
                child: Container(
                  width: 100,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      bottomItems[index],
                      style: TextStyle(fontSize: 18, color: white),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ));
          }),
        ),
      ),
    );
  }
}
