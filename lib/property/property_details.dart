import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justhomm/common/api.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:justhomm/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PropertyDetails extends StatefulWidget {
  final String propertyId;
  final String propertyName;
  final String coverImage;

  PropertyDetails({
    @required this.propertyId,
    this.propertyName,
    this.coverImage,
  });

  @override
  _PropertyDetailsState createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String propertyId;
  String propertyName;
  var responsePropertyDetail;
  String propertyType;
  String projectAddress;
  var minBudget;
  var maxBudget;
  var userTags;
  String file;
  var propertyPhotos;
  var latitude;
  var longitude;
  String roomType;
  String location;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  bool _isLoading;
  bool _permissionReady;
  String _localPath;

  @override
  void initState() {
    super.initState();
    propertyName = widget.propertyName;
    Future.delayed(Duration.zero, this.getPropertyDetails);
    _isLoading = true;
    _permissionReady = false;
    _prepare();
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  getPropertyDetails() async {
    propertyId = widget.propertyId;
    responsePropertyDetail = await API().getPropertyDetails(propertyId);
    responsePropertyDetail = responsePropertyDetail['data'];
    propertyType = responsePropertyDetail['property_type'];
    projectAddress = responsePropertyDetail['project_address'];
    minBudget = responsePropertyDetail['min_budget']
        .toString()
        .replaceAllMapped(reg, mathFunc);
    maxBudget = responsePropertyDetail['max_budget']
        .toString()
        .replaceAllMapped(reg, mathFunc);
    if (responsePropertyDetail['project_master_file'] != null) {
      file = responsePropertyDetail['project_master_file'][0]['file'];
    } else {
      file = '';
    }

    latitude = responsePropertyDetail['latitude'];
    longitude = responsePropertyDetail['longitude'];
    location = responsePropertyDetail['location'];
    propertyPhotos = responsePropertyDetail['property_photo'];
    if (responsePropertyDetail['_user_tags'] != null) {
      userTags = responsePropertyDetail['_user_tags'];
      var userTagsSplit = userTags.split(',');
      userTagsSplit.remove('');
      roomType = userTagsSplit.join(', ');
    } else {
      roomType = 'N/A';
    }
    setState(() {});
    // print(propertyPhotos);
    // print(responsePropertyDetail['property_photo'].length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white70,
      resizeToAvoidBottomPadding: false,
      body: propertyType != null
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Hero(
                          tag: API().apiURL + widget.coverImage,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0),
                            ),
                            child: Image(
                              image: NetworkImage(
                                API().apiURL + widget.coverImage,
                              ),
                              fit: BoxFit.cover,
                              color: Colors.white,
                              colorBlendMode: BlendMode.dstATop,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 40.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 30.0,
                              color: Colors.black,
                              onPressed: () => Navigator.pop(context),
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  iconSize: 30.0,
                                  color: Colors.red,
                                  onPressed: () {
                                    print('favourite pressed');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.share),
                                  iconSize: 30.0,
                                  color: Colors.red,
                                  onPressed: () {
                                    print('share pressed');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20.0,
                        bottom: 20.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.propertyName.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.home,
                                  size: 20.0,
                                  color: Colors.white70,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  propertyType,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 18.0,
                    ),
                    child: Container(
                      height: 230.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/homepage-bg-2.jpg"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.3),
                            BlendMode.dstATop,
                          ),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: 25.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  location,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.hotel,
                                  size: 25.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  roomType,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.rupeeSign,
                                  size: 25.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  "$minBudget - $maxBudget",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: SizedBox(
                              width: 300.0,
                              child: FlatButton.icon(
                                icon: Icon(Icons.map),
                                label: Text('VIEW ON MAP'),
                                color: Colors.white,
                                textColor: Colors.red,
                                padding: const EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                                onPressed: () {
                                  print(latitude);
                                  print(longitude);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final taskId = await FlutterDownloader.enqueue(
                          url: API().apiURL + file,
                          savedDir: _localPath,
                          showNotification: true,
                          openFileFromNotification: true,
                        );
                        print(taskId);
                        if (taskId != null) {
                          final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Downloading file...'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.green,
                          );
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          Timer(new Duration(seconds: 3), () async {
                            _scaffoldKey.currentState.hideCurrentSnackBar();
                          });
                        }
                        // FlutterDownloader.open(taskId: taskId);
                      },
                      child: Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Download property documents'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 18.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 300.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 18.0,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Other property images'.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CarouselSlider.builder(
                                itemCount: propertyPhotos.length,
                                itemBuilder:
                                    (BuildContext context, int itemIndex) {
                                  return Container(
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(API().apiURL +
                                            propertyPhotos[itemIndex]['image']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black38,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                viewportFraction: 0.9,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                pauseAutoPlayOnTouch: Duration(seconds: 10),
                                enlargeCenterPage: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 18.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.black87,
                            padding: const EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.black87),
                            ),
                            child: Text(
                              'SEND INQUIRY',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              print('Send Inquiry');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        backgroundColor: JustHomm().homeButton,
        elevation: 15.0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
