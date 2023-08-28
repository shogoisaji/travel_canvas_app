import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:travel_canvas/application/feature/database.dart';
import 'package:travel_canvas/application/state/state.dart';
import 'package:travel_canvas/presentation/theme/tag.dart';
import 'package:travel_canvas/presentation/theme/theme.dart';
import 'package:flutter/rendering.dart';
import 'package:travel_canvas/presentation/widgets/list_card.dart';

class YourMapPage extends StatefulHookConsumerWidget {
  const YourMapPage({super.key});

  @override
  YourMapPageState createState() => YourMapPageState();
}

class YourMapPageState extends ConsumerState<YourMapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng _initialPosition;
  late bool _loading;
  int? markerTapState;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _determinePosition();
  }

  Future<Set<Marker>> _createMarkers(String tag) async {
    Position? position;

    final dataFuture = await DatabaseHelper.instance.queryAllRows();
    Set<Marker> markers = {};

    for (int i = 0; i < dataFuture.length; i++) {
      if (dataFuture[i][DatabaseHelper.columnPosition] == '') continue;
      if (tag != 'tagAll') {
        if (dataFuture[i][DatabaseHelper.columnTag] != tag) continue;
      }
// position
      final positionMap =
          jsonDecode(dataFuture[i][DatabaseHelper.columnPosition]);
      position = Position.fromMap(positionMap);
// image
      final markerImagePath = dataFuture[i][DatabaseHelper.columnMarkerImage];

//markerImageからBitmapDescriptorを取得
      File imageFile = File(markerImagePath);
      BitmapDescriptor customIcon =
          await getBitmapDescriptorFromFile(imageFile);

      markers.add(
        Marker(
            markerId:
                MarkerId(dataFuture[i][DatabaseHelper.columnId].toString()),
            position: LatLng(position.latitude, position.longitude),
            icon: customIcon,
            onTap: () =>
                _onMarkerClick(dataFuture[i][DatabaseHelper.columnId])),
      );
    }
    return markers;
  }

  _onMarkerClick(int markerId) {
    setState(() {
      markerTapState = markerId;
    });
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromFile(File file) async {
    Uint8List bytes = await file.readAsBytes();
    return BitmapDescriptor.fromBytes(bytes);
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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyTheme myTheme = MyTheme();
    Map<String, Color> myTagColor = MyTag().tagColor;
    final selectedTag = ref.watch(sortTagMarkerProvider);
    final Future<Map<String, dynamic>?>? selectedMarkerData =
        useMemoized(() => DatabaseHelper.instance.findById(markerTapState));

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Text('Your Map', style: myTheme.subTitle),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
// map
          Center(
            child: Container(
                width: double.infinity,
                height: 550,
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: _loading
                    ? const Center(
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()),
                      )
                    : FutureBuilder<Set<Marker>>(
                        future: _createMarkers(selectedTag),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('エラーが発生しました: ${snapshot.error}');
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GoogleMap(
                              markers: snapshot.data!,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: _initialPosition,
                                zoom: 12.0,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          );
                        },
                      )),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
              color: myTheme.grey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(sortTagMarkerProvider.notifier)
                            .changeTag('tagAll');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/all_color.png'), // AssetImageを使用
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                spreadRadius: 0.7,
                                blurRadius: 3,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            border: selectedTag == 'tagAll'
                                ? Border.all(color: myTheme.darkNavy, width: 4)
                                : Border.all(color: Colors.white38, width: 1)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(sortTagMarkerProvider.notifier)
                            .changeTag('tagRed');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: myTagColor['tagRed'],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                spreadRadius: 0.7,
                                blurRadius: 3,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            border: selectedTag == 'tagRed'
                                ? Border.all(color: myTheme.darkNavy, width: 4)
                                : Border.all(color: Colors.white54, width: 1)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(sortTagMarkerProvider.notifier)
                            .changeTag('tagPink');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: myTagColor['tagPink'],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                spreadRadius: 0.7,
                                blurRadius: 3,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            border: selectedTag == 'tagPink'
                                ? Border.all(color: myTheme.darkNavy, width: 4)
                                : Border.all(color: Colors.white38, width: 1)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(sortTagMarkerProvider.notifier)
                            .changeTag('tagBlue');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: myTagColor['tagBlue'],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                spreadRadius: 0.7,
                                blurRadius: 3,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            border: selectedTag == 'tagBlue'
                                ? Border.all(color: myTheme.darkNavy, width: 4)
                                : Border.all(color: Colors.white38, width: 1)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(sortTagMarkerProvider.notifier)
                            .changeTag('tagGreen');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: myTagColor['tagGreen'],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                spreadRadius: 0.7,
                                blurRadius: 3,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            border: selectedTag == 'tagGreen'
                                ? Border.all(color: myTheme.darkNavy, width: 4)
                                : Border.all(color: Colors.white38, width: 1)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(sortTagMarkerProvider.notifier)
                            .changeTag('tagYellow');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: myTagColor['tagYellow'],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                spreadRadius: 0.7,
                                blurRadius: 3,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            border: selectedTag == 'tagYellow'
                                ? Border.all(color: myTheme.darkNavy, width: 4)
                                : Border.all(color: Colors.white54, width: 1)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            height: 380,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: selectedMarkerData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return const Text('エラーが発生しました');
                }
                final data = snapshot.data;
                return data != null
                    ? listCard(context, data, ref)
                    : Container();
              },
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
