import 'package:csv/csv.dart';
import 'dart:convert';
import '../../../core/instrument.dart';
class InstrumentParser{
    static Future<List<Instrument>> parse(file) async{
        var instruments = <Instrument>[];
        // var input = file.openRead();
        // var list = await input.transform(utf8.decoder).transform(const CsvToListConverter(eol:'\n')).toList();
        // list.removeAt(0);
        // for(var x in list){
        //     instruments.add(Instrument(x[0],x[2]));
        // }
        return instruments;
    }
    
}