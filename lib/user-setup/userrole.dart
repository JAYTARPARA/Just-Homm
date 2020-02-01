import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:justhomm/common/api.dart';
import 'package:justhomm/common/common.dart';
import 'package:justhomm/user-setup/homepage.dart';
import 'package:justhomm/user-setup/login.dart';
import 'package:justhomm/other-pages/profile.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UserRole extends StatefulWidget {
  final String mobile;
  UserRole({this.mobile});

  @override
  _UserRoleState createState() => _UserRoleState();
}

class _UserRoleState extends State<UserRole> {
  ProgressDialog pr;
  var responseUserRole;
  var setUserRole;

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Saving your info...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/home",
            (r) => false,
            arguments: HomePage(
              mobile: widget.mobile,
            ),
          );
          // return true;
        },
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 180.0,
                          width: 180.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'WHO ARE YOU?',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'I am a',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              // Call API to register user role
                              print('Mobile: ${widget.mobile}');
                              print('Role: Customer');
                              pr.show();
                              setUserRole = await API().setRole('Buyer');

                              if (setUserRole != null) {
                                pr.hide().then((isHidden) async {
                                  responseUserRole = await Common().writeData(
                                    'userrole',
                                    'customer',
                                  );
                                  GlobalConfiguration().updateValue("role", "customer");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(),
                                    ),
                                  );
                                });
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(180.0),
                              child: Image.asset(
                                'assets/images/customer-hd.png',
                                width: 100,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              // Call API to register user role
                              print('Mobile: ${widget.mobile}');
                              print('Role: Broker');
                              pr.show();
                              setUserRole = await API().setRole('Agent');
                              pr.hide();
                              if (setUserRole != null) {
                                pr.hide().then((isHidden) async {
                                  responseUserRole = await Common().writeData(
                                    'userrole',
                                    'broker',
                                  );
                                  GlobalConfiguration().updateValue("role", "broker");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Profile(),
                                    ),
                                  );
                                });
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(180.0),
                              child: Image.asset(
                                'assets/images/broker-hd.png',
                                width: 100,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
