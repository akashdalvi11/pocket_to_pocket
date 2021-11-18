import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../uiAdapter.dart';
import 'operations.dart';
import 'ui_help.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('Open the drawer')),
      drawer: Operations(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<UIAdapter>(
                builder: (context, model, _) => 
                ListView.builder(
                  itemCount:model.trades.keys.length,
                  itemBuilder: (BuildContext context,int index){
                    var om = model.trades.keys.toList()[index];
                    var trades = model.trades[om]!;
                    return ExpansionTile(
                      title:Text('$om'),
                      children:[
                        ListView.builder(
                          shrinkWrap:true,
                          physics:ClampingScrollPhysics(),
                          itemCount:trades.length,
                          itemBuilder: (BuildContext context,int index){
                            return ListTile(
                              title:Text('${trades[index]}')
                              );
                          }
                        )
                      ]
                    );
                  }
                )
              )
            )
          ]
        )
      )
    );
  }
}
