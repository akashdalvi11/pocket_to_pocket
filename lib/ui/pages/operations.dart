import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../uiAdapter.dart';
class Operations extends StatelessWidget{
    static Future<DateTime?> _selectDate(BuildContext context,DateTime selectedDate) async {
        return await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now().subtract(Duration(days:30)),
            lastDate: DateTime.now()
            );     
    }
    @override
    Widget build(BuildContext buildContext){
        return Consumer<UIAdapter>(
            builder:(context,model,_)=> Drawer(
                child:Column(
                    children:[
                        Container(height:100),
                        Center(child: Text(model.historicalBufferStart.toString())),
                        ElevatedButton(
                            onPressed:() async{
                              model.changeBufferStart(
                                await _selectDate(context,model.historicalBufferStart)
                                );
                            },
                            child:Text('pick historical buffer')
                        ), 
                        Center(child: Text(model.historicalEntry.toString())),
                        ElevatedButton(
                            onPressed:() async{
                              model.changeHistoricalEntry(
                                await _selectDate(context,model.historicalEntry)
                                );
                            },
                            child:Text('pick historical entry')
                        ),
                        ElevatedButton(onPressed:model.bankNiftyAdded?null:(model.addObserver), 
                            child: Text(model.bankNiftyAdded?'running':'start normal')
                        ),
                        ElevatedButton(onPressed:model.bankNiftyAdded?(model.removeObserver):null, 
                            child: Text(model.bankNiftyAdded?'stop normal':'notstarted')
                        ),
                        ElevatedButton(onPressed:model.addHistoricalObserver, 
                            child: Text('historical')
                        ),
                        ElevatedButton(onPressed:model.test, 
                            child: Text('test')
                        )
                    ]
                )
            )
        );
    }
}