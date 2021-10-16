import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
class WSWrapper {
  final WebSocketChannel ws;
  WSWrapper(this.ws);
  subscribe(int token) {
    ws.sink.add(jsonEncode({"a": "mode", "v": ["ltp",[token]]}));
  }

  unsubscribe(int token) {
    ws.sink.add(jsonEncode({"a": "unsubscribe", "v": [token]}));
  }
  close() {
    ws.sink.close();
  }
}


