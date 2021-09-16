import 'package:flutter/material.dart';
import '../uiAdapter.dart';
import 'package:provider/provider.dart';
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String? failure;
  void loadRepo() async {
	var result = await Provider.of<UIAdapter>(context).initializeBackend();
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
                ? ElevatedButton(
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
