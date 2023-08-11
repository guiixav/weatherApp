// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

WeatherInfoWeek weatherInfoFromJson(String str) =>
    WeatherInfoWeek.fromJson(json.decode(str));

//String weatherInfoToJson(WeatherInfo data) => json.encode(data.toJson());

class WeatherInfoWeek {
  final double latitude;
  final double longitude;
  //final Hourly? hourly;
  final Daily? daily;
  //final CurrentWeather? currentWeather;

  WeatherInfoWeek({
    required this.latitude,
    required this.longitude,
    //this.hourly,
    required this.daily,
    //this.currentWeather,
  });

  factory WeatherInfoWeek.fromJson(Map<String?, dynamic> json) =>
      WeatherInfoWeek(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        //hourly: Hourly.fromJson(json?["hourly"]),
        daily: Daily.fromJson(json["daily"]),
        //currentWeather: CurrentWeather.fromJson(json["current_weather"]),
      );

  //Map<String, dynamic> toJson() => {
  //      "latitude": latitude,
  //      "longitude": longitude,
  //      "hourly": hourly.toJson(),
  //      "current_weather": currentWeather.toJson(),
  //    };
}

// class CurrentWeather {
//   final String time;
//   final double temperature;
//   final double windspeed;

//   CurrentWeather({
//     required this.time,
//     required this.temperature,
//     required this.windspeed,
//   });

//   factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
//         time: json["time"],
//         temperature: json["temperature"]?.toDouble(),
//         windspeed: json["windspeed"]?.toDouble(),
//       );

//   //Map<String, dynamic> toJson() => {
//   //      "time": time,
//   //      "temperature": temperature,
//   //      "windspeed": windspeed,
//   //    };
// }

// class Hourly {
//   List<String>? time;
//   List<double>? temperature2M;

//   Hourly({
//     this.time,
//     this.temperature2M,
//   });

//   factory Hourly.fromJson(Map<String?, dynamic> json) => Hourly(
//         time: List<String>.from(json["time"].map((x) => x)),
//         temperature2M:
//             List<double>.from(json["temperature_2m"].map((x) => x?.toDouble())),
//       );

//   //Map<String, dynamic> toJson() => {
//   //      "time": List<dynamic>.from(time.map((x) => x)),
//   //      "temperature_2m": List<dynamic>.from(temperature2M.map((x) => x)),
//   //    };
// }

class Daily {
  List<String> time;
  List<double> temperature2Mmin;
  List<double> temperature2Mmax;
  List<int> weatherCode;

  Daily({
    required this.time,
    required this.temperature2Mmin,
    required this.temperature2Mmax,
    required this.weatherCode,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        time: List<String>.from(json["time"].map((x) => x)),
        temperature2Mmin: List<double>.from(
            json["temperature_2m_min"].map((x) => x?.toDouble())),
        temperature2Mmax: List<double>.from(
            json["temperature_2m_max"].map((x) => x?.toDouble())),
        weatherCode: List<int>.from(json["weathercode"].map((x) => x)),
      );

  //Map<String, dynamic> toJson() => {
  //      "time": List<dynamic>.from(time?.map((x) => x)),
  //      "temperature_2m_max": List<dynamic>.from(temperature2Mmax.map((x) => x)),
  //      "temperature_2m_min": List<dynamic>.from(temperature2Mmin.map((x) => x)),
  //    };
}
