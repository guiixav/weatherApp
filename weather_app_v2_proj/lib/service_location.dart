import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'Models/location_info.dart';
import 'package:http/http.dart' as http;

class LocationService extends StatefulWidget {
  void setState(VoidCallback fn) {}

  Future<Placemark> buscaCidade(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    return placemarks.first;
  }

  Future<List<LocationInfo>> buscaCidadeApi(String nomeLocal) async {
    List<LocationInfo> listaCidades = [];
    try {
      final response = await http.get(Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=$nomeLocal'));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var responseResult = jsonDecode(response.body);
        var listResult = responseResult['results'];
        if (listResult != null) {
          for (int i = 0; i < listResult.length - 1; i++) {
            LocationInfo cidade = LocationInfo.fromJson(listResult[i]);
            listaCidades.add(cidade);
          }
          return listaCidades;
        }
        return listaCidades;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load local');
      }
    } catch (e) {
      throw Exception('Failed to load local');
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
