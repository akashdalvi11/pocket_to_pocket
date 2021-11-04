import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'injector.dart';
import 'ui/uiAdapter.dart';
import 'ui/pages/router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await Firebase.initializeApp();
  await getIt<UIAdapter>().initialiseNotifier();
  // var releaseConfig = CatcherOptions(PageReportMode(),[EmailManualHandler(["akashdalvi115@gmail.com"])]);
  // Catcher(rootWidget:Root(),debugConfig:releaseConfig,releaseConfig:releaseConfig);
  runApp(Root());
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider<UIAdapter>(create:(context)=>getIt<UIAdapter>())
    ],child:
     MaterialApp(
      //  navigatorKey: Catcher.navigatorKey,
        title: 'pocket to pocket',
        onGenerateRoute: getRoutes,
        initialRoute: 'loading-page'));
  }
}
