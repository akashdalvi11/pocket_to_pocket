import 'package:flutter/material.dart';
import 'ui/pages/router.dart';
import 'ui/notifier.dart';
import 'injector.dart';
import 'package:provider/provider.dart';
import 'ui/uiAdapter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await getIt<Notifier>().setupNotifications();
  runApp(Root());
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider<UIAdapter>(create:(context)=>getIt<UIAdapter>())
    ],child:
     MaterialApp(
        title: 'pocket to pocket',
        onGenerateRoute: getRoutes,
        initialRoute: 'loading-page'));
  }
}
