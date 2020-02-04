import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justhomm/common/api.dart';

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

  @override
  void initState() {
    super.initState();
    propertyName = widget.propertyName;
    Future.delayed(Duration.zero, this.getPropertyDetails);
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
    file = responsePropertyDetail['file'];
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
      backgroundColor: Colors.grey,
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
                              widget.propertyName,
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
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ),
            ),
    );
  }
}
