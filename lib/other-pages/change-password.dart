import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:justhomm/common/api.dart';
import 'package:justhomm/common/common.dart';
import 'package:justhomm/main.dart';
import 'package:justhomm/sidebar/sidebar-broker.dart';
import 'package:justhomm/sidebar/sidebar-customer.dart';
import 'package:justhomm/user-setup/homepage.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool validatePassword = false;
  bool validateConfirmPassword = false;
  ProgressDialog pr;
  String responseUserRole;
  bool _obscureText = true;
  bool _obscureTextCP = true;
  var responseChangePassword;

  @override
  void initState() {
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    super.initState();
    responseUserRole = GlobalConfiguration().getString("role");
  }

  @override
  void dispose() {
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      drawer:
          responseUserRole == 'broker' ? SidebarBroker() : SidebarCustomer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Press again to exit'),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 0.0,
                  ),
                  child: TextField(
                    controller: password,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        dragStartBehavior: DragStartBehavior.down,
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      labelText: 'New Password',
                      errorText:
                          validatePassword ? 'Please enter password' : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 0.0,
                  ),
                  child: TextField(
                    controller: confirmPassword,
                    obscureText: _obscureTextCP,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        dragStartBehavior: DragStartBehavior.down,
                        onTap: () {
                          setState(() {
                            _obscureTextCP = !_obscureTextCP;
                          });
                        },
                        child: Icon(
                          _obscureTextCP
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      labelText: 'Confirm Password',
                      errorText: validateConfirmPassword
                          ? 'Please enter same password as new password'
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 10.0,
                          bottom: 20.0,
                        ),
                        child: RaisedButton(
                          color: Colors.black87,
                          padding: const EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black87),
                          ),
                          child: Text(
                            'CHANGE PASSWORD',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              password.text.isEmpty
                                  ? validatePassword = true
                                  : validatePassword = false;

                              if (confirmPassword.text.isEmpty) {
                                validateConfirmPassword = true;
                              } else if (confirmPassword.text !=
                                  password.text) {
                                validateConfirmPassword = true;
                              } else {
                                validateConfirmPassword = false;
                              }
                            });
                            if (!validatePassword && !validateConfirmPassword) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              pr.style(
                                message: 'Updating password...',
                              );
                              pr.show();
                              responseChangePassword =
                                  await API().changePassword(password.text);
                              if (responseChangePassword != null) {
                                if (responseChangePassword['data'] != null) {
                                  pr.hide().then((isHidden) async {
                                    await Common().logOut();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      "/home",
                                      (r) => false,
                                      arguments: HomePage(
                                        functionCall: '1',
                                      ),
                                    );
                                  });
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 0.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '*AFTER PASSWORD CHANGE, YOU WILL BE LOGGED OUT AND NEED TO LOGIN AGAIN.',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.red,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        backgroundColor: JustHomm().homeButton,
        elevation: 15.0,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/property-list",
            (r) => false,
          );
        },
      ),
    );
  }
}
