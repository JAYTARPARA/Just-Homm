import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:justhomm/common/api.dart';
import 'package:justhomm/common/common.dart';
import 'package:justhomm/sidebar/sidebar-broker.dart';
import 'package:justhomm/sidebar/sidebar-customer.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:justhomm/user-setup/homepage.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PropertyList extends StatefulWidget {
  final String project_name;
  final String name;
  final String location;
  final String property_type;
  String user_tags;
  final String thumbnail;
  PropertyList({
    this.project_name,
    this.name,
    this.location,
    this.property_type,
    this.user_tags,
    this.thumbnail,
  });

  @override
  _PropertyListState createState() => _PropertyListState();

  // factory PropertyList.fromJson(List<dynamic> parsedJson) {
  // print(parsedJson);
  // return PropertyList(
  //   project_name: parsedJson['project_name'],
  //   name: parsedJson['name'],
  //   location: parsedJson['location'],
  //   property_type: parsedJson['property_type'],
  //   user_tags: parsedJson['_user_tags'],
  //   thumbnail: parsedJson['thumbnail'],
  // );
  // }
}

class _PropertyListState extends State<PropertyList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String responseUserRole;
  String fullName;
  ProgressDialog pr;
  var responsePropertyData;
  PropertyList propertyList;
  List<PropertyList> propertyItems = [];

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    responseUserRole = GlobalConfiguration().getString("role");
    Future.delayed(Duration.zero, this.checkUser);
  }

  checkUser() async {
    fullName = await API().getName();
    print(fullName);
    if (fullName != null) {
      if (fullName == 'error') {
        await Common().logOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/home",
          (r) => false,
          arguments: HomePage(
            functionCall: '1',
          ),
        );
      } else if (fullName == '') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/profile",
          (r) => false,
        );
      } else {
        getAllProperties();
      }
    }
  }

  getAllProperties() async {
    responsePropertyData = await API().getAllProperties();
    if (responsePropertyData != null) {
      responsePropertyData = responsePropertyData['message'];
      propertyItems = new List<PropertyList>();
      for (var i = 0; i < responsePropertyData.length; i++) {
        // print(responsePropertyData[i]['project_name']);
        propertyItems.add(
          PropertyList(
            project_name: responsePropertyData[i]['project_name'],
            name: responsePropertyData[i]['name'],
            location: responsePropertyData[i]['location'],
            property_type: responsePropertyData[i]['property_type'],
            user_tags: responsePropertyData[i]['_user_tags'],
            thumbnail: responsePropertyData[i]['thumbnail'],
          ),
        );
      }
      setState(() {});
    }
    // if (responsePropertyData != null) {
    //   propertyList = PropertyList.fromJson(responsePropertyData['message']);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('All Properties'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('Show me filter');
            },
          )
        ],
      ),
      drawer:
          responseUserRole == 'broker' ? SidebarBroker() : SidebarCustomer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Press again to exit'),
        ),
        child: responsePropertyData != null
            ? ListView.builder(
                itemCount: propertyItems.length,
                itemBuilder: (context, index) {
                  final property = propertyItems[index];
                  if (property.user_tags != null) {
                    property.user_tags = property.user_tags.substring(1);
                  } else {
                    property.user_tags = 'N/A';
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        index == 0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      '${propertyItems.length} properties found near you',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                  ],
                                ),
                              )
                            : Padding(padding: EdgeInsets.all(0.0)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: PageView(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  print(property.name);
                                },
                                child: Card(
                                  color: Colors.white24,
                                  margin: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 24,
                                  ),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(32)),
                                        child: Image.network(
                                          'https://desk.justhomm.com' +
                                              property.thumbnail,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          fit: BoxFit.none,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              property.project_name
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(Icons.location_on),
                                            SizedBox(width: 8.0),
                                            Text(
                                              property.location,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(Icons.hotel),
                                            SizedBox(width: 8.0),
                                            Text(
                                              property.user_tags,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
      ),
    );
  }
}
