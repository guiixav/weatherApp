import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService extends StatefulWidget {
  void setState() {
    // TODO: implement setState
  }

  Future<Position> geolocationHandle() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Geolocation is not avaiable, please enable it in your App settings');
        //return 'Geolocation is not avaiable, please enable it in your App settings';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Geolocation is not avaiable, please enable it in your App settings');
      // Permissions are denied forever, handle appropriately.
      //return 'Geolocation is not avaiable, please enable it in your App settings';
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
