import 'package:broncorideshare/pages/signInPage.dart';
import 'package:broncorideshare/pages/introPage.dart';
import 'package:broncorideshare/pages/welcomePage.dart';
import 'package:broncorideshare/users/UserData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:broncorideshare/utils/appState.dart';

void main() {
  //this was add to ensure the data that we waited for are pushed into our app
  WidgetsFlutterBinding.ensureInitialized();

  //State Management & DI
  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AppState(),),
    ChangeNotifierProvider.value(value: UserData(),)
  ],
    child: MyApp(),));
}
//var routes = <String, WidgetBuilder>{
//  "/intro": (BuildContext context) => IntroScreen(),
//};


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bronco RideShare',
      theme: ThemeData(

        primaryColor: Colors.red,
        accentColor: Colors.yellowAccent,
      ),
      debugShowCheckedModeBanner: false,
//      home: WelcomeScreen(),
      home: welcomePage(),
//        home: WelcomeScreen(),
//      routes: routes,
    );
  }
}
