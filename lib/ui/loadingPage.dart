import 'package:flutter/material.dart';
import '../infrastructure/endPoint/endPointHandler.dart';
import '../injector.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String? failure;
  void loadRepo() async {
	var result = await getIt<EndPointHandler>().init();
    if(result == null){
        Navigator.pushReplacementNamed(context, 'home-page');
    }else{
      setState(() {
        failure = result;
      });
    }
  }

  @override
  void initState() {
    loadRepo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(title:Text(failure??"nothing")),
        body: Center(
            child: failure != null
                ? RaisedButton(
                    child: Text('try again'),
                    onPressed: () {
                      loadRepo();
                      setState(() {
                        failure = null;
                      });
                    })
                : CircularProgressIndicator()));
  }
}
