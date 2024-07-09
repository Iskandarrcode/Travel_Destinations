import 'package:dars8/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:location/location.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final searchLocationText = TextEditingController();
  late GoogleMapController myController;
  final LatLng najotTalim = const LatLng(41.2855806, 69.2034646);
  LatLng myCurrentPosition = const LatLng(41.2855806, 69.2034646);
  Location location = Location();

  Set<Marker> myMarkers = {};
  Set<Polyline> polyline = {};
  List<LatLng> myPositions = [];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  void _checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var locationData = await location.getLocation();
    setState(() {
      myController.moveCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  void onCameraMove(CameraPosition position) {
    setState(() {
      myCurrentPosition = position.target;
    });
  }

  void addLocation() {
  myMarkers.add(
    Marker(
      markerId: MarkerId(myMarkers.length.toString()),
      position: myCurrentPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
  );

  myPositions.add(myCurrentPosition);

  if (myPositions.length == 2) {
    LocationService.fetchPolylinePoints(
      myPositions[0],
      myPositions[1],
    ).then((List<LatLng> positions) {
      setState(() {
        polyline.add(
          Polyline(
            polylineId: PolylineId(UniqueKey().toString()),
            color: Colors.blue,
            width: 5,
            points: positions, // Update with fetched points
          ),
        );
      });
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: GoogleMap(
                mapType: MapType.hybrid,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: najotTalim,
                  zoom: 16.0,
                ),
                onCameraMove: onCameraMove,
                markers: {
                  Marker(
                    markerId: const MarkerId("NajotTa'lim"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: najotTalim,
                    infoWindow: const InfoWindow(
                      title: "Najot Ta'lim",
                      snippet: "Xush Kelibsiz IT Maktabiga",
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId("MyCurrentPosition"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue,
                    ),
                    position: myCurrentPosition,
                    infoWindow: const InfoWindow(
                      title: "MyCurrentPosition",
                      snippet: "Xush Kelibsiz IT Maktabiga",
                    ),
                  ),
                  ...myMarkers,
                },
                polylines: polyline,
              ),
            ),
            Positioned(
              top: 5,
              left: 50,
              right: 54,
              child: GooglePlacesAutoCompleteTextFormField(
                keyboardType: TextInputType.text,
                textEditingController: searchLocationText,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(205, 255, 255, 255),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search location",
                ),
                googleAPIKey: "AIzaSyAwm88ULyquBykcwNDR7t7rCDhvNGstFSo",
                debounceTime: 400, // defaults to 600 ms
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (prediction) {
                  print("Coordinates: (${prediction.lat},${prediction.lng})");
                },
                itmClick: (prediction) {
                  searchLocationText.text = prediction.description!;
                  searchLocationText.selection = TextSelection.fromPosition(
                    TextPosition(
                      offset: prediction.description!.length,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 110,
              right: 5,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: ZoomTapAnimation(
                    onTap: () {
                      addLocation();
                    },
                    child: const Icon(
                      Icons.directions_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: 300,
            //   left: 150,
            //   child: IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.location_on,
            //       color: Colors.amber,
            //       size: 50,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
