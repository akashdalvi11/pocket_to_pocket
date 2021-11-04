import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
class WSWrapper {
  final WebSocketChannel _ws;
  late Stream stream;
  WSWrapper(this._ws){
    stream = _ws.stream;
  }
  subscribe(int token) {
    _ws.sink.add(jsonEncode({"a": "mode", "v": ["ltp",[token]]}));
  }

  unsubscribe(int token) {
    _ws.sink.add(jsonEncode({"a": "unsubscribe", "v": [token]}));
  }
  close() {
    _ws.sink.close();
  }
}


