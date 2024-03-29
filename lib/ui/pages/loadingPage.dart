import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../uiAdapter.dart';
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String? failure;
  void loadRepo() async {
	var result = await Provider.of<UIAdapter>(context,listen:false).initializeBackend();
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
    super.initState();
    loadRepo();
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
