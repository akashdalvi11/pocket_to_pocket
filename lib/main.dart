import 'package:flutter/material.dart';
import 'ui/router.dart';
import 'ui/notifier.dart';
import 'injector.dart';
import 'package:provider/provider.dart';
import 'ui/homeAdapter.dart';
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
      ChangeNotifierProvider<HomeAdapter>(create:(context)=>HomeAdapter())
    ],child:
     MaterialApp(
        title: 'pocket to pocket',
        onGenerateRoute: getRoutes,
        initialRoute: 'loading-page'));
  }
}
