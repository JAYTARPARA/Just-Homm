import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:justhomm/other-pages/change-password.dart';
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
  await FlutterDownloader.initialize();
  runApp(JustHomm());
}

class JustHomm extends StatelessWidget {
  final Color homeButton = Colors.orange;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
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
          '/change-password': (BuildContext context) => new ChangePassword(),
        },
      ),
    );
  }
}
