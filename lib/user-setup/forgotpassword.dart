import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:justhomm/user-setup/login.dart';
import 'package:justhomm/common/api.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _mobile = TextEditingController();
  bool _validate = false;
  var responsePassword;
  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    _mobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(0xFFDF513B)),
      ),
      body: SingleChildScrollView(
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
                            'Send Password',
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
                            });
                            if (!_validate) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              // API call for password send
                              print('Mobile: ${_mobile.text}');
                              pr.style(
                                message: 'Sending password...',
                              );
                              pr.show();
                              responsePassword =
                                  await API().sendPassword(_mobile.text);
                              if (responsePassword != null) {
                                pr.hide().then((isHidden) {
                                  final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'We have sent your password on ${_mobile.text}',
                                    ),
                                    duration: Duration(seconds: 4),
                                    backgroundColor: Colors.green,
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                  Timer(new Duration(seconds: 4), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  });
                                });
                              }
                            }
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
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                              child: Text(
                                'Go to login page',
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
    );
  }
}
