import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:justhomm/common/api.dart';
import 'package:justhomm/common/common.dart';
import 'package:justhomm/main.dart';
import 'package:justhomm/property/property_details.dart';
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
}

class _PropertyListState extends State<PropertyList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String responseUserRole;
  String fullName;
  ProgressDialog pr;
  var responsePropertyData;
  PropertyList propertyList;
  List<PropertyList> propertyItems = [];
  ScrollController _scrollController;
  bool _isOnTop = true;
  bool doSplit = true;

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
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isOnTop = false;
          doSplit = false;
        });
      } else {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          setState(() {
            _isOnTop = false;
            doSplit = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    setState(() {
      _isOnTop = true;
      doSplit = false;
    });
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
      setState(() {
        // doSplit = false;
      });
    }
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
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: propertyItems.length,
                itemBuilder: (context, index) {
                  final property = propertyItems[index];
                  if (doSplit) {
                    if (property.user_tags != null) {
                      property.user_tags = property.user_tags.substring(1);
                    } else {
                      property.user_tags = 'N/A';
                    }
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
                          height: MediaQuery.of(context).size.height * 0.56,
                          child: PageView(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    doSplit = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PropertyDetails(
                                        propertyId: property.name,
                                        propertyName: property.project_name,
                                        coverImage: property.thumbnail,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.white54,
                                  margin: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 24,
                                  ),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(8),
                                        ),
                                        child: Image.network(
                                          API().apiURL + property.thumbnail,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              property.project_name
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.favorite_border,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                print('Favourite pressed');
                                              },
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
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
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
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
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
      floatingActionButton: Visibility(
        visible: !_isOnTop,
        child: FloatingActionButton(
          onPressed: !_isOnTop ? _scrollToTop : null,
          child: Icon(Icons.home),
          backgroundColor: JustHomm().homeButton,
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       title: Text('All Properties'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_offer),
      //       title: Text('Advertisory Properties'),
      //     ),
      //   ],
      // ),
    );
  }
}
