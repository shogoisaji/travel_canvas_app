import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key, this.position});
  final Position? position;

  @override
  State<GoogleMapWidget> createState() => GoogleMapWidgetState();
}

class GoogleMapWidgetState extends State<GoogleMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng _initialPosition;
  late bool _loading;

  Set<Marker> _createMarker() {
    _initialPosition =
        LatLng(widget.position!.latitude, widget.position!.longitude);
    return {
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
      ),
    };
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    _determinePosition();
    // if (widget.position != null) {
    //   debugPrint('position exist');
    //   _initialPosition =
    //       LatLng(widget.position!.latitude, widget.position!.longitude);
    // }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    setState(() {
      // _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500,
      // margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: _loading
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GoogleMap(
                markers: _createMarker(),
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: _initialPosition, zoom: 14.4746),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
    );
  }
}
