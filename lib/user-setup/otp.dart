import 'package:flutter/material.dart';
import 'package:justhomm/user-setup/login.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:justhomm/common/api.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Otp extends StatefulWidget {
  final String mobile;
  Otp({this.mobile});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var responseOTP, responseVerifyOTP;
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFF4364A1),
      appBar: AppBar(
        backgroundColor: Color(0xFF4364A1),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Enter 4 digit OTP sent to ${widget.mobile}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PinEntryTextField(
                    showFieldAsBox: true,
                    fieldWidth: 60.0,
                    onSubmit: (String pin) async {
                      // Call API for check mobile and OTP
                      print('Pin: $pin');
                      pr.style(
                        message: 'Verifying OTP...',
                      );
                      pr.show();
                      responseVerifyOTP = await API().verifyOTP(
                        widget.mobile,
                        pin,
                      );
                      if (responseVerifyOTP != null) {
                        pr.hide().then((isHidden) {
                          if (responseVerifyOTP == "error") {
                            final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Something went wrong! Please click on button again.',
                              ),
                              duration: Duration(seconds: 4),
                              backgroundColor: Colors.red,
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            if (responseVerifyOTP['message'] == "OTP Verify") {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => UserRole(
                              //       mobile: widget.mobile,
                              //     ),
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(
                                    mobile: widget.mobile,
                                  ),
                                ),
                              );
                            } else if (responseVerifyOTP['message'] ==
                                "Wrong OTP") {
                              final snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'OTP enetered is wrong',
                                ),
                                duration: Duration(seconds: 4),
                                backgroundColor: Colors.red,
                              );
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          }
                        });
                      }
                    }, // end onSubmit
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: GestureDetector(
                        onTap: () async {
                          // Send OTP again to the number
                          print('Mobile: ${widget.mobile}');
                          pr.style(
                            message: 'Sending OTP...',
                          );
                          pr.show();
                          responseOTP = await API().sendOTP(widget.mobile);
                          if (responseOTP != null) {
                            pr.hide().then((isHidden) {
                              if (responseOTP == "error") {
                                final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Something went wrong! Please click on Send OTP button again.',
                                  ),
                                  duration: Duration(seconds: 4),
                                  backgroundColor: Colors.red,
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              } else {
                                if (responseOTP['message'] == "OTP Sent") {
                                  final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'OTP has been sent',
                                    ),
                                    duration: Duration(seconds: 4),
                                    backgroundColor: Colors.green,
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }
                              }
                            });
                          }
                        },
                        child: Text(
                          'Haven\'t you received OTP? Send it again',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
