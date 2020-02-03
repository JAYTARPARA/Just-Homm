import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:justhomm/common/api.dart';
import 'package:justhomm/common/common.dart';
import 'package:justhomm/main.dart';
import 'package:justhomm/sidebar/sidebar-broker.dart';
import 'package:justhomm/sidebar/sidebar-customer.dart';
import 'package:justhomm/user-setup/homepage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:email_validator/email_validator.dart';

class Profile extends StatefulWidget {
  final String first_name;
  final String middle_name;
  final String last_name;
  final String address;
  String gender = 'Male';
  final String dob;
  final String email;
  Profile({
    this.first_name,
    this.middle_name,
    this.last_name,
    this.address,
    this.gender,
    this.dob,
    this.email,
  });

  @override
  _ProfileState createState() => _ProfileState();

  factory Profile.fromJson(Map<String, dynamic> parsedJson) {
    return Profile(
      first_name: parsedJson['first_name'],
      middle_name: parsedJson['middel_name'],
      last_name: parsedJson['last_name'],
      address: parsedJson['address'],
      gender: parsedJson['gender'],
      dob: parsedJson['dob'],
      email: parsedJson['email'],
    );
  }
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;
  String responseUserRole;
  var responseUserData;
  var responseProfileSave;
  TextEditingController first_name = TextEditingController();
  TextEditingController middle_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  bool validate_first_name = false;
  bool validate_last_name = false;
  bool validate_address = false;
  bool validate_gender = false;
  bool validate_dob = false;
  bool validate_email = false;

  @override
  void initState() {
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    super.initState();
    responseUserRole = GlobalConfiguration().getString("role");
    getUserData();
  }

  getUserData() async {
    responseUserData = await API().getUserData();
    // print(responseUserData);
    pr.style(
      message: 'Getting your details...',
    );
    pr.show();
    if (responseUserData == 'error') {
      pr.hide();
      await Common().logOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/home",
        (r) => false,
        arguments: HomePage(
          functionCall: '1',
        ),
      );
    } else {
      Timer(new Duration(seconds: 1), () async {
        pr.hide().then((isHidden) async {
          Profile userProfile = Profile.fromJson(responseUserData['message']);
          setState(() {
            first_name.text =
                userProfile.first_name != null ? userProfile.first_name : '';
            middle_name.text =
                userProfile.middle_name != null ? userProfile.middle_name : '';
            last_name.text =
                userProfile.last_name != null ? userProfile.last_name : '';
            email.text = userProfile.email != null ? userProfile.email : '';
            address.text =
                userProfile.address != null ? userProfile.address : '';
            gender.text =
                userProfile.gender != null ? userProfile.gender : 'Male';
            if (gender.text == '' || gender.text == null) {
              gender.text = 'Male';
            }
            dob.text = userProfile.dob != null ? userProfile.dob : '';
          });
          print(gender.text);
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    first_name.dispose();
    middle_name.dispose();
    last_name.dispose();
    address.dispose();
    email.dispose();
    gender.dispose();
    dob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('My Profile'),
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
                    controller: first_name,
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
                      labelText: 'First Name',
                      errorText: validate_first_name
                          ? 'Please enter first name'
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
                    controller: middle_name,
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
                      labelText: 'Middle Name',
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
                    controller: last_name,
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
                      labelText: 'Last Name',
                      errorText:
                          validate_last_name ? 'Please enter last name' : null,
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
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
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
                      labelText: 'Email Address',
                      errorText: validate_email
                          ? 'Please enter valid email address'
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
                    controller: address,
                    maxLines: 4,
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
                      labelText: 'Address',
                      errorText:
                          validate_address ? 'Please enter address' : null,
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
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Select Gender',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RadioListTile(
                        value: 'Male',
                        groupValue: gender.text,
                        title: Text('Male'),
                        onChanged: (value) {
                          setState(() {
                            gender.text = value;
                          });
                        },
                        activeColor: Colors.black87,
                      ),
                      RadioListTile(
                        value: 'Female',
                        groupValue: gender.text,
                        title: Text('Female'),
                        onChanged: (value) {
                          setState(() {
                            gender.text = value;
                          });
                        },
                        activeColor: Colors.black87,
                      ),
                      RadioListTile(
                        value: 'Other',
                        groupValue: gender.text,
                        title: Text('Other'),
                        onChanged: (value) {
                          setState(() {
                            gender.text = value;
                          });
                        },
                        activeColor: Colors.black87,
                      ),
                    ],
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
                  child: DateTimeField(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      errorText:
                          validate_dob ? 'Please select date of birth' : null,
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
                    ),
                    autovalidate: true,
                    format: DateFormat("dd-MM-yyyy"),
                    controller: dob,
                    onChanged: (dobVal) {
                      setState(() {
                        dob.text = DateFormat("dd-MM-yyyy").format(dobVal);
                      });
                    },
                    onShowPicker: (context, currentValue) async {
                      return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime.now(),
                      );
                    },
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
                            'SAVE PROFILE',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              first_name.text.isEmpty
                                  ? validate_first_name = true
                                  : validate_first_name = false;

                              last_name.text.isEmpty
                                  ? validate_last_name = true
                                  : validate_last_name = false;

                              address.text.isEmpty
                                  ? validate_address = true
                                  : validate_address = false;

                              gender.text.isEmpty
                                  ? validate_gender = true
                                  : validate_gender = false;

                              dob.text.isEmpty
                                  ? validate_dob = true
                                  : validate_dob = false;

                              if (email.text.isNotEmpty) {
                                !EmailValidator.validate(email.text)
                                    ? validate_email = true
                                    : validate_email = false;
                              } else {
                                validate_email = false;
                              }
                            });
                            if (!validate_first_name &&
                                !validate_last_name &&
                                !validate_address &&
                                !validate_gender &&
                                !validate_email &&
                                !validate_dob) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              pr.style(
                                message: 'Saving your profile...',
                              );
                              pr.show();
                              responseProfileSave = await API().saveUserData(
                                first_name.text,
                                middle_name.text,
                                last_name.text,
                                address.text,
                                gender.text,
                                email.text,
                                dob.text,
                              );
                              print(responseProfileSave);
                              if (responseProfileSave != null) {
                                pr.hide().then((isHidden) async {
                                  Profile savedUserProfile = Profile.fromJson(
                                      responseProfileSave['message']);
                                  setState(() {
                                    first_name.text =
                                        savedUserProfile.first_name != null
                                            ? savedUserProfile.first_name
                                            : '';
                                    middle_name.text =
                                        savedUserProfile.middle_name != null
                                            ? savedUserProfile.middle_name
                                            : '';
                                    last_name.text =
                                        savedUserProfile.last_name != null
                                            ? savedUserProfile.last_name
                                            : '';
                                    email.text = savedUserProfile.email != null
                                        ? savedUserProfile.email
                                        : '';
                                    address.text =
                                        savedUserProfile.address != null
                                            ? savedUserProfile.address
                                            : '';
                                    gender.text =
                                        savedUserProfile.gender != null
                                            ? savedUserProfile.gender
                                            : 'Male';
                                    dob.text = savedUserProfile.dob != null
                                        ? savedUserProfile.dob
                                        : '';
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
