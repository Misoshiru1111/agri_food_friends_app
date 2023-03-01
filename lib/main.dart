import 'package:agri_food_freind/history/camera.dart';
import 'package:agri_food_freind/myData.dart';
import 'package:agri_food_freind/sign.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitness_app/fitness_app_home_screen.dart';
import 'home.dart';
import 'welcome.dart';
import 'post.dart';

main() async {
  runApp(MyApp());
}
abstract class Main extends StatefulWidget{
  const Main({super.key});
   String get userName;
}

class MyApp extends StatefulWidget {
  // final String userName;
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => MyappState();
}

class MyappState extends State<MyApp> {
  String userName = "";

  _loadUser() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    setState(() {
      if (prefs.containsKey(Name.userName)) {
        userName = prefs.getString(Name.userName) ?? "";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '食農好朋友',
      theme: ThemeData(),
      home: SafeArea(
        child: userName != "" ?  Home( userName: userName,) : const Welcome(),
        // child: Container(),
      ),
      routes: <String, WidgetBuilder>{
        'welcome': (_) => const Welcome(),
        'home': (_) =>  Home(userName: userName),
        'post': (_) =>  Post(userName: userName),
        'scan': (_) =>  Camera(userName: userName),
        'login': (_) =>  Login(),
        'fit': (_) => const FitnessAppHomeScreen(),

      },
    ); // TODO: implement build
    throw UnimplementedError();
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
