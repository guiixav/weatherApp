import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:weather_app_v2_proj/Models/location_info.dart';
import 'package:weather_app_v2_proj/service_weather.dart';
import 'service_geolocation.dart';
import 'service_location.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true),
      home: const MyHomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<LocationInfo> listLocations = [];

class _MyHomePageState extends State<MyHomePage> {
  //final TextEditingController _searchController = TextEditingController();
  Clima clima = Clima();
  Clima clima2 = Clima();
  String displaytextAtual = '';
  String displaytextAtualNome = '';
  String displaytextAtualRegiao = '';
  String displaytextAtualPais = '';
  String displaytextAtualTemp = '';
  String displaytextAtualDesc = '';
  String displaytextAtualVento = '';
  String displaytextDia = '';
  List<String> listaHoraDia = [];
  List<double> listaTempDia = [];
  List<double> listaWindDia = [];
  List<int> listaWeatherCodeDia = [];
  List<String> listaWeatherDescription = [];

  List<double> listaTempMax = [];
  List<double> listaTempMin = [];
  List<String> listaTimeWeek = [];
  List<int> listaWeatherCodeWeek = [];
  List<String> listaWeatherDescriptionWeek = [];
  //String nomeLocal = '';
  GeolocationService geolocation = GeolocationService();
  LocationService location = LocationService();
  weatherService weather = weatherService();

  @override
  void initState() {
    buscaLocalizacao();
    super.initState();
  }

  buscaLocalizacao() async {
    try {
      geolocator.Position geo = await geolocation.geolocationHandle();
      // String latitude = geo.latitude.toString();
      // String longitude = geo.longitude.toString();
      Placemark placemark =
          await location.buscaCidade(geo.latitude, geo.longitude);
      String? name = placemark.locality;
      // String resultado = 'Latitude: $latitude , Longitude: $longitude';
      // List<LocationInfo> localInfo = await buscaLocalPeloNome(name!.toString());
      await buscaClimaAtualeDiaGeolocation(
          geo.latitude, geo.longitude, placemark);
      await buscaClimaSemanalGeolocation(
          geo.latitude, geo.longitude, placemark);
    } catch (e) {
      setState(() {
        displaytextAtual = 'Erro ao buscar clima';
        displaytextDia = 'Erro ao buscar clima';
      });
    }
    // setState(() {
    //   displaytextAtual = resultado;
    // });
  }

  Future<List<LocationInfo>> buscaLocalPeloNome(String nomeLocal) async {
    listLocations = await location.buscaCidadeApi(nomeLocal);
    return listLocations;
    //return stringMapper();
  }

  List<String> stringMapper() {
    List<String> listString = [];
    if (listLocations.isNotEmpty) {
      for (int i = 0; i < listLocations.length - 1; i++) {
        if (listLocations[i].region == null) {
          listString
              .add('${listLocations[i].name} ${listLocations[i].country}');
        } else {
          listString.add(
              '${listLocations[i].name} ${listLocations[i].region.toString()} , ${listLocations[i].country}');
        }
      }
    }
    return listString;
  }

  Clima converteCodigo(List<int> listCodigo, Clima clima) {
    clima.listaDescricao = [];
    clima.listaIcon = [];
    for (int i = 0; i < listCodigo.length - 1; i++) {
      if (listCodigo[i] == 0) {
        clima.listaDescricao.add('Clear sky');
        clima.listaIcon.add(Icons.wb_sunny_outlined);
      }
      if (listCodigo[i] == 1 || listCodigo[i] == 2 || listCodigo[i] == 3) {
        clima.listaDescricao.add('Mainly clear, partly cloudy, and overcast');
        clima.listaIcon.add(Icons.brightness_low_outlined);
      }
      if (listCodigo[i] == 45 || listCodigo[i] == 48) {
        clima.listaDescricao.add('Fog and depositing rime fog');
        clima.listaIcon.add(Icons.lens_blur_outlined);
      }
      if (listCodigo[i] == 51 || listCodigo[i] == 53 || listCodigo[i] == 55) {
        clima.listaDescricao
            .add('Drizzle: Light, moderate, and dense intensity');
        clima.listaIcon.add(Icons.water_drop_outlined);
      }
      if (listCodigo[i] == 56 || listCodigo[i] == 57) {
        clima.listaDescricao.add('Freezing Drizzle: Light and dense intensity');
        clima.listaIcon.add(Icons.air_outlined);
      }
      if (listCodigo[i] == 61 || listCodigo[i] == 63 || listCodigo[i] == 65) {
        clima.listaDescricao.add('Rain: Slight, moderate and heavy intensity');
        clima.listaIcon.add(Icons.umbrella_outlined);
      }
      if (listCodigo[i] == 66 || listCodigo[i] == 67) {
        clima.listaDescricao.add('Freezing Rain: Light and heavy intensity');
        clima.listaIcon.add(Icons.umbrella_outlined);
      }
      if (listCodigo[i] == 71 || listCodigo[i] == 73 || listCodigo[i] == 75) {
        clima.listaDescricao
            .add('Snow fall: Slight, moderate, and heavy intensity');
        clima.listaIcon.add(Icons.ac_unit_outlined);
      }
      if (listCodigo[i] == 80 || listCodigo[i] == 81 || listCodigo[i] == 82) {
        clima.listaDescricao.add('Rain showers: Slight, moderate, and violent');
        clima.listaIcon.add(Icons.umbrella_outlined);
      }
      if (listCodigo[i] == 85 || listCodigo[i] == 86) {
        clima.listaDescricao.add('Snow showers slight and heavy');
        clima.listaIcon.add(Icons.grain_outlined);
      }
      if (listCodigo[i] == 95) {
        clima.listaDescricao.add('Thunderstorm: Slight or moderate');
        clima.listaIcon.add(Icons.thunderstorm_outlined);
      }
      if (listCodigo[i] == 96 || listCodigo[i] == 99) {
        clima.listaDescricao.add('Thunderstorm with slight and heavy hail');
        clima.listaIcon.add(Icons.thunderstorm_outlined);
      }
      if (listCodigo[i] == 77) {
        clima.listaDescricao.add('Snow grains');
        clima.listaIcon.add(Icons.grain_outlined);
      }
    }
    return clima;
  }

  buscaClimaAtualeDia(LocationInfo locationInfo) async {
    displaytextAtual = '';
    displaytextDia = '';
    displaytextAtual = '';
    displaytextAtualNome = '';
    displaytextAtualRegiao = '';
    displaytextAtualPais = '';
    displaytextAtualTemp = '';
    displaytextAtualDesc = '';
    displaytextAtualVento = '';
    var weatherResult = await weather.buscaClimaAtualeDia(
        locationInfo.latitude, locationInfo.longitude);
    String textoTelaAtual = locationInfo.name;
    String textoTelaDia = textoTelaAtual;
    listaHoraDia = weatherResult.hourly!.time;
    listaTempDia = weatherResult.hourly!.temperature2M;
    listaWindDia = weatherResult.hourly!.wind;
    listaWeatherCodeDia = weatherResult.hourly!.weatherCode;
    listaWeatherDescription =
        converteCodigo(listaWeatherCodeDia, clima).listaDescricao;

    if (locationInfo.region != null) {
      textoTelaAtual += '\n${locationInfo.region}';
    }
    if (locationInfo.country != null) {
      textoTelaAtual += '\n${locationInfo.country}';
    }
    textoTelaDia = textoTelaAtual;
    textoTelaAtual +=
        '\n${weatherResult.currentWeather?.temperature.toString()} °C\n${weatherResult.currentWeather?.windspeed.toString()}km/h';

    setState(() {
      displaytextAtualTemp =
          '${weatherResult.currentWeather?.temperature.toString()} °C';
      displaytextAtualNome = locationInfo.name.toString();
      displaytextAtualPais = locationInfo.country.toString();
      displaytextAtualRegiao = locationInfo.region.toString();
      displaytextAtualVento =
          '${weatherResult.currentWeather?.windspeed.toString()} km/h';
      displaytextAtualDesc = listaWeatherDescription[0];
      displaytextDia = textoTelaDia;
    });
    displaytextAtual = textoTelaAtual;
    displaytextDia = textoTelaDia;
  }

  buscaClimaAtualeDiaGeolocation(
      double lat, double long, Placemark placemark) async {
    try {
      displaytextAtual = '';
      displaytextDia = '';
      var weatherResult = await weather.buscaClimaAtualeDia(lat, long);
      String textoTelaAtual = placemark.locality.toString();
      String textoTelaDia = textoTelaAtual;
      listaHoraDia = weatherResult.hourly!.time;
      listaTempDia = weatherResult.hourly!.temperature2M;
      listaWindDia = weatherResult.hourly!.wind;
      listaWeatherCodeDia = weatherResult.hourly!.weatherCode;
      listaWeatherDescription =
          converteCodigo(listaWeatherCodeDia, clima).listaDescricao;

      if (placemark.administrativeArea != null) {
        textoTelaAtual += '\n${placemark.administrativeArea}';
      }
      if (placemark.country != null) {
        textoTelaAtual += '\n${placemark.country}';
      }
      textoTelaDia = textoTelaAtual;
      textoTelaAtual +=
          '\n${weatherResult.currentWeather?.temperature.toString()} °C\n${weatherResult.currentWeather?.windspeed.toString()}km/h\n ${listaWeatherDescriptionWeek[0]}';
      debugPrint(textoTelaAtual);
      setState(() {
        displaytextAtualTemp =
            '${weatherResult.currentWeather?.temperature.toString()} °C';
        displaytextAtualNome = placemark.locality.toString();
        displaytextAtualPais = placemark.country.toString();
        displaytextAtualRegiao = placemark.administrativeArea.toString();
        displaytextAtualVento =
            '${weatherResult.currentWeather?.windspeed.toString()} km/h';
        displaytextAtualDesc = listaWeatherDescription[0];
        displaytextDia = textoTelaDia;
      });
    } catch (e) {
      setState(() {
        displaytextAtual = 'Erro ao buscar clima';
        displaytextDia = 'Erro ao buscar clima';
      });
    }
  }

  buscaClimaSemanal(LocationInfo locationInfo) async {
    displaytextDia = '';
    var weatherResult = await weather.buscaClimaSemanal(
        locationInfo.latitude, locationInfo.longitude);
    String textoTelaAtual = locationInfo.name;
    String textoTelaDia = textoTelaAtual;
    listaTempMax = weatherResult.daily!.temperature2Mmax;
    listaTempMin = weatherResult.daily!.temperature2Mmin;
    listaTimeWeek = weatherResult.daily!.time;
    listaWeatherCodeWeek = weatherResult.daily!.weatherCode;
    listaWeatherDescriptionWeek =
        converteCodigo(listaWeatherCodeWeek, clima2).listaDescricao;

    if (locationInfo.region != null) {
      textoTelaAtual += '\n${locationInfo.region}';
    }
    if (locationInfo.country != null) {
      textoTelaAtual += '\n${locationInfo.country}';
    }
    textoTelaDia = textoTelaAtual;
    //textoTelaAtual +=
    //    '\n${weatherResult.currentWeather?.temperature.toString()} C\n${weatherResult.currentWeather?.windspeed.toString()}km/h';

    setState(() {});
    displaytextDia = textoTelaDia;
  }

  buscaClimaSemanalGeolocation(
      double lat, double long, Placemark placemark) async {
    try {
      displaytextDia = '';
      var weatherResult = await weather.buscaClimaSemanal(lat, long);
      String textoTelaAtual = placemark.locality.toString();
      String textoTelaDia = textoTelaAtual;
      listaTempMax = weatherResult.daily!.temperature2Mmax;
      listaTempMin = weatherResult.daily!.temperature2Mmin;
      listaTimeWeek = weatherResult.daily!.time;
      listaWeatherCodeWeek = weatherResult.daily!.weatherCode;
      listaWeatherDescriptionWeek =
          converteCodigo(listaWeatherCodeWeek, clima2).listaDescricao;

      if (placemark.administrativeArea != null) {
        textoTelaAtual += '\n${placemark.administrativeArea}';
      }
      if (placemark.country != null) {
        textoTelaAtual += '\n${placemark.country}';
      }
      textoTelaDia = textoTelaAtual;
      //textoTelaAtual +=
      //    '\n${weatherResult.currentWeather?.temperature.toString()} C\n${weatherResult.currentWeather?.windspeed.toString()}km/h';

      setState(() {});
      displaytextDia = textoTelaDia;
    } catch (e) {
      setState(() {
        displaytextDia = 'Erro ao buscar clima';
      });
    }
  }

  Future<List<LocationInfo>> _fetchSuggestions(LocationInfo query) async {
    return listLocations.take(5).toList();
  }

  void retornaWidgetDia() {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                toolbarHeight: 50,
                backgroundColor: Colors.deepPurple,
                leading: const Icon(Icons.search, color: Colors.greenAccent),
                title: TypeAheadField(
                  textFieldConfiguration: const TextFieldConfiguration(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a search Location',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  onSuggestionSelected: (suggestion) {
                    buscaClimaAtualeDia(suggestion);
                    buscaClimaSemanal(suggestion);
                  },
                  suggestionsCallback: (String pattern) async {
                    List<LocationInfo> teste =
                        await buscaLocalPeloNome(pattern);
                    return teste.take(5);
                    //return stringMapper();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                        leading: const Icon(Icons.place),
                        title: Expanded(
                            child: Row(children: [
                          Expanded(
                              child: Text(
                            '${suggestion.name} ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                          Expanded(
                              child: Text(
                                  '${suggestion.region ?? ''}, ${suggestion.country} ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300))),
                        ])));
                  },
                ),
                actions: <Widget>[
                  IconButton(
                      color: Colors.greenAccent,
                      icon: const Icon(Icons.near_me_rounded),
                      onPressed: () async {
                        await buscaLocalizacao();
                        //alteraTextoTela('Geolocation');
                      })
                ]),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("image/imagem.jpg"),
                  fit: BoxFit.cover, // Ajusta a imagem ao tamanho da tela
                ),
              ),
              child: TabBarView(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: null,
                      // gradient: LinearGradient(
                      //   begin: Alignment.topRight,
                      //   end: Alignment.bottomLeft,
                      //   colors: [
                      //     Colors.greenAccent,
                      //     Colors.deepPurple,
                      //   ],
                    ),
                    child: Center(child: buildText()),
                  ),
                  Container(
                      decoration: const BoxDecoration(color: null
                          //     gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     Colors.greenAccent,
                          //     Colors.deepPurple,
                          //   ],
                          // )
                          ),
                      child: Center(
                          child: displaytextDia == 'Erro ao buscar clima'
                              ? Text(displaytextDia,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                              : buildTable()
                          // Text(displaytextDia,
                          //     style: const TextStyle(
                          //         fontWeight: FontWeight.bold, fontSize: 14))),
                          )),
                  Container(
                      decoration: const BoxDecoration(color: null
                          //     gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     Colors.greenAccent,
                          //     Colors.deepPurple,
                          //   ],
                          // )
                          ),
                      child: Center(
                        child: displaytextDia == 'Erro ao buscar clima'
                            ? Text(displaytextDia,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14))
                            : buildTableWeek(),
                      ))
                ],
              ),
            ),
            bottomNavigationBar: Container(
                color: Colors.deepPurple,
                child: const TabBar(tabs: [
                  Tab(
                      icon: Icon(Icons.settings, color: Colors.greenAccent),
                      child: Text('Currently',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.greenAccent))),
                  Tab(
                      icon: Icon(Icons.today, color: Colors.greenAccent),
                      child: Text('Today',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.greenAccent))),
                  Tab(
                      icon: Icon(Icons.date_range, color: Colors.greenAccent),
                      child: Text('Weekly',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.greenAccent)))
                ]))));
  }

  Widget buildTable() {
    List<Card> tableRow = [];
    List<ChartData> listflspot = [];
    if (listaHoraDia.isNotEmpty || listaTempDia.isNotEmpty) {
      for (int i = 0; i < listaHoraDia!.length - 1; i++) {
        listflspot.add(ChartData(
            listaHoraDia[i].substring(11, listaHoraDia[i].length - 1),
            listaTempDia[i]));
        tableRow.add(Card(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Text(
              listaHoraDia![i],
              textAlign: TextAlign.center,
            ),
            Text('${listaTempDia![i].toString()} C',
                textAlign: TextAlign.center),
            Text('${listaWindDia![i].toString()} km/h',
                textAlign: TextAlign.center),
            //Text(listaWeatherDescription[i], textAlign: TextAlign.center)
            Icon(clima.listaIcon[i])
          ]),
        )));
      }
      Container grafico = Container(
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
            // Renders line chart
            LineSeries<ChartData, String>(
                dataSource: listflspot,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
          ]));

      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  displaytextDia,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Temperature over the hours:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                grafico,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: tableRow),
                )
              ]));
    }
    return Text('');
  }

  Widget buildTableWeek() {
    List<Card> tableRow = [];
    List<ChartData> listflspot = [];
    List<ChartData> listflspot2 = [];
    if (listaHoraDia.isNotEmpty || listaTempDia.isNotEmpty) {
      for (int i = 0; i < listaTimeWeek.length - 1; i++) {
        listflspot.add(ChartData(listaTimeWeek[i], listaTempMax[i]));
        listflspot2.add(ChartData(listaTimeWeek[i], listaTempMin[i]));
        tableRow.add(Card(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    listaTimeWeek![i],
                    textAlign: TextAlign.center,
                  ),
                  Text('${listaTempMax[i].toString()} C',
                      textAlign: TextAlign.center),
                  Text('${listaTempMin[i].toString()} C',
                      textAlign: TextAlign.center),
                  //Text(listaWeatherDescriptionWeek[i],
                  //    textAlign: TextAlign.center)
                  Icon(clima2.listaIcon[i])
                ],
              )),
        ));
      }
      Container grafico = Container(
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
            // Renders line chart
            LineSeries<ChartData, String>(
                dataSource: listflspot,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y),
            LineSeries<ChartData, String>(
                dataSource: listflspot2,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
          ]));

      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  displaytextDia,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Max and Min Temperature over the days:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                grafico,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: tableRow),
                )
              ]));
    }
    return Text('');
  }

  Widget buildText() {
    return Container(
        child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              displaytextAtualTemp,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              displaytextAtualNome,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              displaytextAtualPais,
              textAlign: TextAlign.center,
            ),
            Text(
              displaytextAtualRegiao,
              textAlign: TextAlign.center,
            ),
            Text(
              displaytextAtualDesc,
              textAlign: TextAlign.center,
            ),
            Icon(
              clima.listaIcon.isEmpty ? null : clima.listaIcon[0],
              color: Colors.blue,
              size: 30,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(clima.listaIcon.isEmpty ? null : Icons.speed_outlined,
                      color: Colors.blue),
                  Text(displaytextAtualVento)
                ])
          ]),
    ));
  }
}

class Clima {
  List<String> listaDescricao = [];
  List<IconData> listaIcon = [];
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
