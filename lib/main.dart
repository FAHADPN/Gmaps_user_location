import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  static const _initialCameraPosition = CameraPosition(
      target: LatLng(10.2277, 76.1971),
    zoom: 11.5,
  ); //Initial camera position
  GoogleMapController _googleMapController;
  LatLng _center;
  Position currentLocation;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    getUserLocation(); // User location when app starts
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } //returns user location high accuracy from gps module
  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  } //User location captured

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
          children:[
            GoogleMap(
              myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller)=> _googleMapController = controller,
        ),
      ]
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () =>
          { getUserLocation(),
            _googleMapController.animateCamera(
              CameraUpdate.newLatLngZoom(_center, 17.5)
          ),
          },
          child: const Icon(
              Icons.my_location_sharp,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
