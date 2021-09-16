import 'package:flutter/material.dart';
import 'ui_help.dart';
import 'package:provider/provider.dart';

import 'homeAdapter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeAdapter>(
        builder: (context, model, child) => Scaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(model.message)),
                  ElevatedButton(onPressed: model.test, child: Text('test'))
                ],
              )),
            ));
  }
}
