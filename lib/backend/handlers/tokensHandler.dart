import 'package:csv/csv.dart';
import 'dart:convert';
import '../../../core/instrument.dart';
class TokensHandler{
    final List<Instrument> instruments;
    TokensHandler(this.instruments);
    static Future<TokensHandler> create(file) async{
        var instruments = <Instrument>[];
        var input = file.openRead();
        var list = await input.transform(utf8.decoder).transform(const CsvToListConverter(eol:'\n')).toList();
        list.removeAt(0);
        for(var x in list){
            instruments.add(Instrument(x[0],x[2]));
        }
        return TokensHandler(instruments);
    }
    List<Instrument> getOptionTokens(String name,DateTime expiry){
        var filtered = <Instrument>[];
        for(var x in instruments){
            if(x.name.contains(name+'${expiry.year}${expiry.month}${expiry.day}')) filtered.add(x);
        }
        return filtered;
    }
}