import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2_proj/Models/weather_info_daily.dart';
import 'package:weather_app_v2_proj/Models/weather_info_week.dart';

class weatherService extends StatefulWidget {
  const weatherService({super.key});

  @override
  State<weatherService> createState() => _weatherService();

  Future<WeatherInfoDay> buscaClimaAtualeDia(
      double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,weathercode,windspeed_120m&current_weather=true&start_date=${DateTime.now().toString().substring(0, 10)}&end_date=${DateTime.now().toString().substring(0, 10)}'));
      if (response.statusCode == 200) {
        var resultado = jsonDecode(response.body);
        WeatherInfoDay weatherInfo = WeatherInfoDay.fromJson(resultado);
        return weatherInfo;
      }
      throw Exception('Failed to load local');
    } catch (e) {
      throw Exception('Failed to load informations about temperature');
    }
  }

  Future<WeatherInfoWeek> buscaClimaSemanal(
      double latitude, double longitude) async {
    try {
      var data = DateTime.now(); //.toString().substring(0, 10);
      var semana = data.add(const Duration(days: 6));

      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&timezone=America/Sao_Paulo&start_date=${data.toString().substring(0, 10)}&end_date=${semana.toString().substring(0, 10)}&daily=weathercode,temperature_2m_max,temperature_2m_min'));
      if (response.statusCode == 200) {
        var resultado = jsonDecode(response.body);
        WeatherInfoWeek weatherInfo = WeatherInfoWeek.fromJson(resultado);
        return weatherInfo;
      }
      throw Exception('Failed to load local');
    } catch (e) {
      throw Exception('Failed to load informations about temperature');
    }
  }
}

class _weatherService extends State<weatherService> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
