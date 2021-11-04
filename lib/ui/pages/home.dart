import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../uiAdapter.dart';
import 'ui_help.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UIAdapter>(
        builder: (context, model, child) => Scaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:model.signals.length,
                      itemBuilder: (BuildContext context,int index){
                        return ListTile(title:Text(model.signals[index].toString()));
                      }
                    )
                  ),
                  ElevatedButton(onPressed:model.test,child:Text("send signal")),
                  ElevatedButton(onPressed:model.buttonEnabled?(model.start):null, child: Text(model.buttonEnabled?'start':'running'))
                ],
              )),
            ));
  }
}
