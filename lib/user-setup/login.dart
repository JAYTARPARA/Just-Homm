import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:justhomm/common/common.dart';
import 'package:justhomm/user-setup/forgotpassword.dart';
import 'package:justhomm/user-setup/signup.dart';
import 'package:justhomm/common/api.dart';
import 'package:justhomm/user-setup/userrole.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Login extends StatefulWidget {
  final String mobile;
  Login({this.mobile});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  bool _validate = false;
  bool _validatePass = false;
  var responseLogin;
  var responseRole;
  var userRole;
  ProgressDialog pr;
  bool _obscureText = true;
  String name;
  var responseLoggedin;

  @override
  void initState() {
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    super.initState();
    _mobile.text = widget.mobile != null ? widget.mobile : '';
  }

  @override
  void dispose() {
    _mobile.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(0xFFDF513B)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
          // return true;
        },
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 150.0,
                            width: 150.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 0.0,
                    ),
                    child: TextField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      controller: _mobile,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
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
                        labelText: 'Mobile Number',
                        errorText: _validate
                            ? 'Please enter 10 digit mobile number'
                            : null,
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
                      controller: _password,
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
                        labelText: 'Password',
                        errorText:
                            _validatePass ? 'Please enter password' : null,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
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
                            onPressed: () async {
                              setState(() {
                                _mobile.text.isEmpty || _mobile.text.length < 10
                                    ? _validate = true
                                    : _validate = false;

                                _password.text.isEmpty
                                    ? _validatePass = true
                                    : _validatePass = false;
                              });
                              if (!_validate && !_validatePass) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                // API call for login
                                print('Mobile: ${_mobile.text}');
                                print('Password: ${_password.text}');
                                pr.style(
                                  message: 'Logging in...',
                                );
                                pr.show();
                                responseLogin = await API().checkLogin(
                                  _mobile.text,
                                  _password.text,
                                );
                                if (responseLogin != null) {
                                  pr.hide().then((isHidden) async {
                                    if (responseLogin == "error") {
                                      final snackBar = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'Something went wrong! Please click on Login button again.',
                                        ),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.red,
                                      );
                                      _scaffoldKey.currentState
                                          .showSnackBar(snackBar);
                                    } else {
                                      if (responseLogin['message'] ==
                                              'Logged In' ||
                                          responseLogin['message'] ==
                                              'No App') {
                                        GlobalConfiguration().updateValue(
                                          "mobile",
                                          _mobile.text,
                                        );
                                        responseRole = await API().getRole();
                                        pr.style(
                                          message: 'Getting your details...',
                                        );
                                        pr.show();
                                        print(responseRole['message'].length);
                                        if (responseRole != null) {
                                          name = await API().getName();
                                          pr.hide().then((isHidden) async {
                                            if (responseRole['message']
                                                .contains('Agent')) {
                                              userRole = 'Agent';
                                              GlobalConfiguration().updateValue(
                                                "role",
                                                "broker",
                                              );
                                              await Common().writeData(
                                                'userrole',
                                                'broker',
                                              );
                                            } else if (responseRole['message']
                                                .contains('Buyer')) {
                                              userRole = 'Buyer';
                                              GlobalConfiguration().updateValue(
                                                "role",
                                                "customer",
                                              );
                                              await Common().writeData(
                                                'userrole',
                                                'customer',
                                              );
                                            } else {
                                              userRole = 'New';
                                            }
                                            print('userRole: ');
                                            print(userRole);
                                            if (userRole == 'Agent') {
                                              if (name == '' || name == null) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  "/profile",
                                                  (r) => false,
                                                );
                                              } else {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  "/property-list",
                                                  (r) => false,
                                                );
                                              }
                                            } else if (userRole == 'Buyer') {
                                              if (name == '' || name == null) {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  "/profile",
                                                  (r) => false,
                                                );
                                              } else {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  "/property-list",
                                                  (r) => false,
                                                );
                                              }
                                            } else if (userRole == 'New') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserRole(
                                                    mobile: widget.mobile,
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                        }
                                        responseLoggedin =
                                            await Common().writeData(
                                          'loggedin',
                                          'yes',
                                        );
                                        await Common().writeData(
                                          'loggedout',
                                          '',
                                        );
                                        await Common().writeData(
                                          'mobile',
                                          _mobile.text,
                                        );
                                      } else if (responseLogin['message'] ==
                                          'Incorrect password') {
                                        final snackBar = SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            'Password is wrong',
                                          ),
                                          duration: Duration(seconds: 4),
                                          backgroundColor: Colors.red,
                                        );
                                        _scaffoldKey.currentState
                                            .showSnackBar(snackBar);
                                      } else if (responseLogin['message'] ==
                                          'User disabled or missing') {
                                        final snackBar = SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            'Mobile number is wrong or not registered',
                                          ),
                                          duration: Duration(seconds: 4),
                                          backgroundColor: Colors.red,
                                        );
                                        _scaffoldKey.currentState
                                            .showSnackBar(snackBar);
                                      } else {
                                        final snackBar = SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            'Something went wrong! Please try again later',
                                          ),
                                          duration: Duration(seconds: 4),
                                          backgroundColor: Colors.red,
                                        );
                                        _scaffoldKey.currentState
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  });
                                }
                              }
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
                          child: FlatButton(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xFFDF513B),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/inner-page-bg.jpg",
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Signup(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Create a new account',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: Color(0xFFDF513B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
