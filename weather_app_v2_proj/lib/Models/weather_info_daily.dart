// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

WeatherInfoDay weatherInfoFromJson(String str) =>
    WeatherInfoDay.fromJson(json.decode(str));

//String weatherInfoToJson(WeatherInfo data) => json.encode(data.toJson());

class WeatherInfoDay {
  final double latitude;
  final double longitude;
  final Hourly? hourly;
  final CurrentWeather? currentWeather;

  WeatherInfoDay({
    required this.latitude,
    required this.longitude,
    this.hourly,
    this.currentWeather,
  });

  factory WeatherInfoDay.fromJson(Map<String?, dynamic> json) => WeatherInfoDay(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        hourly: Hourly.fromJson(json?["hourly"]),
        //daily: Daily.fromJson(json?["daily"]),
        currentWeather: CurrentWeather.fromJson(json["current_weather"]),
      );

  //Map<String, dynamic> toJson() => {
  //      "latitude": latitude,
  //      "longitude": longitude,
  //      "hourly": hourly.toJson(),
  //      "current_weather": currentWeather.toJson(),
  //    };
}

class CurrentWeather {
  final String time;
  final double temperature;
  final double windspeed;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.windspeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
        time: json["time"],
        temperature: json["temperature"]?.toDouble(),
        windspeed: json["windspeed"]?.toDouble(),
      );

  //Map<String, dynamic> toJson() => {
  //      "time": time,
  //      "temperature": temperature,
  //      "windspeed": windspeed,
  //    };
}

class Hourly {
  List<String> time;
  List<double> temperature2M;
  List<int> weatherCode;
  List<double> wind;

  Hourly(
      {required this.time,
      required this.temperature2M,
      required this.weatherCode,
      required this.wind});

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
        time: List<String>.from(json["time"].map((x) => x)),
        temperature2M:
            List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
        weatherCode: List<int>.from(json["weathercode"].map((x) => x)),
        wind: List<double>.from(json["weathercode"].map((x) => x?.toDouble())),
      );

  //Map<String, dynamic> toJson() => {
  //      "time": List<dynamic>.from(time.map((x) => x)),
  //      "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
  //    };
}
