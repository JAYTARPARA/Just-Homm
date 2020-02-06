import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PropertyMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String propertyName;

  PropertyMap({
    this.latitude,
    this.longitude,
    this.propertyName,
  });

  @override
  _PropertyMapState createState() => _PropertyMapState();
}

class _PropertyMapState extends State<PropertyMap> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  BitmapDescriptor myIcon;
  static double wLatitude;
  static double wLongitude;

  @override
  void initState() {
    super.initState();
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(devicePixelRatio: 3.5), 'assets/images/icon.png')
    //     .then((onValue) {
    //   myIcon = onValue;
    // });
    wLatitude = widget.latitude;
    wLongitude = widget.longitude;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    Timer(new Duration(seconds: 1), () async {
      _onAddMarkerButtonPressed();
    });
  }

  // LatLng _lastMapPosition = _center;

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(LatLng(
          widget.latitude,
          widget.longitude,
        ).toString()),
        position: LatLng(
          widget.latitude,
          widget.longitude,
        ),
        infoWindow: InfoWindow(
          title: widget.propertyName,
          snippet: 'Just Homm Property',
        ),
        icon: BitmapDescriptor.defaultMarker,
        // icon: myIcon,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    // _lastMapPosition = LatLng(
    //   widget.latitude,
    //   widget.longitude,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            // target: _center,
            target: LatLng(
              widget.latitude,
              widget.longitude,
            ),
            zoom: 15.0,
          ),
          onCameraMove: _onCameraMove,
          markers: _markers,
        ),
      ],
    );
  }
}
