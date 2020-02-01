import 'package:flutter/material.dart';
import 'package:justhomm/user-setup/homepage.dart';
import 'package:justhomm/user-setup/login.dart';
import 'package:justhomm/other-pages/profile.dart';
import 'package:justhomm/property/property_list.dart';
import 'package:justhomm/user-setup/signup.dart';
import 'package:justhomm/user-setup/userrole.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  final Map<String, String> justhomm = {
    "role": "customer",
    "mobile": "",
  };
  await GlobalConfiguration().loadFromMap(justhomm);
  runApp(JustHomm());
}

class JustHomm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Homm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        canvasColor: Colors.black87,
        appBarTheme: AppBarTheme(
          color: Colors.black87,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/login': (BuildContext context) => new Login(),
        '/signup': (BuildContext context) => new Signup(),
        '/profile': (BuildContext context) => new Profile(),
        '/property-list': (BuildContext context) => new PropertyList(),
        '/user-role': (BuildContext context) => new UserRole(),
      },
    );
  }
}
