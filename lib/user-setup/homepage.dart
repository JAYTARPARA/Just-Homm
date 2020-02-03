import 'dart:async';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:justhomm/common/api.dart';
import 'package:justhomm/user-setup/login.dart';
import 'package:justhomm/user-setup/signup.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:justhomm/user-setup/userrole.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:justhomm/common/common.dart';

class HomePage extends StatefulWidget {
  final String mobile;
  final String functionCall;
  HomePage({
    this.mobile,
    this.functionCall,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  var responseLoggedin;
  var responseMobile;
  var responseLoggedOut;
  var responseUserRole;
  String fullName;

  @override
  void initState() {
    super.initState();
    if (widget.functionCall == null) {
      Future.delayed(Duration.zero, this.checkIfUserLoggedin);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  showLoggedOutMessage() async {
    responseLoggedOut = await Common().readData('loggedout');
    if (responseLoggedOut != '') {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('You are logged out.'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(new Duration(seconds: 4), () async {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        await Common().writeData(
          'loggedout',
          '',
        );
      });
    }
  }

  checkIfUserLoggedin() async {
    print('Function called');
    showLoggedOutMessage();
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
    );
    pr.show();
    responseLoggedin = await Common().readData('loggedin');
    responseMobile = await Common().readData('mobile');
    print('read: $responseLoggedin');
    Timer(new Duration(seconds: 1), () async {
      if (responseLoggedin == 'yes') {
        GlobalConfiguration().updateValue(
          "mobile",
          responseMobile,
        );
        pr.hide().then((isHidden) async {
          responseUserRole = await Common().readData('userrole');
          GlobalConfiguration().updateValue("role", responseUserRole);
          if (responseUserRole == '') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/user-role",
              (r) => false,
              arguments: UserRole(
                mobile: widget.mobile,
              ),
            );
          } else {
            fullName = await API().getName();
            pr.style(
              message: 'Checking your data...',
            );
            pr.show();
            pr.hide().then((isHidden) async {
              if (fullName == '' || fullName == null) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/profile",
                  (r) => false,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/property-list",
                  (r) => false,
                );
              }
            });
          }
        });
      } else if (responseLoggedin == '') {
        Timer(new Duration(seconds: 1), () {
          pr.hide();
        });
      } else {
        Timer(new Duration(seconds: 1), () {
          pr.hide();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Press again to exit'),
        ),
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/homepage-bg-3.png"),
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 200.0,
                          width: 200.0,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 5.0,
                            top: 10.0,
                          ),
                          child: RaisedButton(
                            color: Color(0xFF4364A1),
                            padding: const EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFF4364A1)),
                            ),
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              print('Signup pressed');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Signup(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 20.0,
                            top: 10.0,
                          ),
                          child: RaisedButton(
                            color: Color(0xFFDF513B),
                            padding: const EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFFDF513B)),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              print('Login pressed');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
