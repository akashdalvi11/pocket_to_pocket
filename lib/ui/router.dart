import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'loadingPage.dart';

MaterialPageRoute getRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case 'loading-page':
      return MaterialPageRoute(builder: (context) => LoadingPage());
    case 'home-page':
      return MaterialPageRoute(builder: (context) => Home());
    default:
      return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text('unknown route'))));
  }
}
