import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HumidityCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const HumidityCard({
    super.key,
    required this.value,
    required this.icon,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 140,
        width: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50,),
            const SizedBox(height: 12,),
            Text(label, style: const TextStyle(
              fontSize: 18,
            ),),
            Text(value, style: const TextStyle(
              fontSize: 15,
            ),),
          ],
        ),
      ),
    );
  }
}

class HourCard extends StatelessWidget {
  final String time;
  final String temp;
  final String wName;
  const HourCard({
    super.key,
    required this.time,
    required this.temp,
    required this.wName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 02,
              sigmaY: 02,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Text(time,
                    style: const TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                      (wName == "Clouds") ? Icons.cloud
                          : (wName == "Rain") ? Icons.cloudy_snowing
                          : (wName == "Clear") ? Icons.sunny
                          : Icons.error,
                      size: 80
                  ),
                  const SizedBox(height: 5),
                  Text(temp, style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late Future<Map<String, dynamic>> _weatherData;

  @override
  void initState() {
    super.initState();
    _weatherData = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      final res = await http.get(
          Uri.parse(
              "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=05c8bc82d9bf31735d95c5f49fd6c779"));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "Error occurred";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 235, 215),
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            "Weather App",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              _weatherData = getCurrentWeather();
            });
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: _weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const CircularProgressIndicator();
          }

          final data = snapshot.data!;
          final lst1 = data["list"][0];
          final lst2 = data["list"][1];
          final lst3 = data["list"][2];
          final lst4 = data["list"][3];
          final lst5 = data["list"][4];
          final lst6 = data["list"][5];

          final Map card2 = {
            "weather": lst2["main"]["temp"],
            "weatherName": lst2["weather"][0]["main"],
            "Time": "12:00"
          };
          final Map card3 = {
            "weather": lst3["main"]["temp"],
            "weatherName": lst3["weather"][0]["main"],
            "Time": "15:00"
          };
          final Map card4 = {
            "weather": lst4["main"]["temp"],
            "weatherName": lst4["weather"][0]["main"],
            "Time": "18:00"
          };
          final Map card5 = {
            "weather": lst5["main"]["temp"],
            "weatherName": lst5["weather"][0]["main"],
            "Time": "21:00"
          };
          final Map card6 = {
            "weather": lst6["main"]["temp"],
            "weatherName": lst6["weather"][0]["main"],
            "Time": "24:00"
          };

          final weather = (lst1["main"]["temp"]);
          final weatherName = (lst1["weather"][0]["main"]);
          final humidity = (lst1["main"]["humidity"]);
          final windSpeed = (lst1["wind"]["speed"]);
          final pressure = (lst1["main"]["pressure"]);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                //maincard
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 07,
                          sigmaY: 07,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text("$weather K",
                                style: const TextStyle(fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                weatherName == "Clouds" || weatherName == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 70,),
                              const SizedBox(height: 10),
                              Text("$weatherName",
                                  style: const TextStyle(fontSize: 20)
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //Weather Forecast
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Weather Forecast",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 5,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourCard(time: card2["Time"], wName: card2["weatherName"],
                          temp: card2["weather"].toString()),
                      HourCard(time: card3["Time"], wName: card3["weatherName"],
                          temp: card3["weather"].toString()),
                      HourCard(time: card4["Time"], wName: card4["weatherName"],
                          temp: card4["weather"].toString()),
                      HourCard(time: card5["Time"], wName: card5["weatherName"],
                          temp: card5["weather"].toString()),
                      HourCard(time: card6["Time"], wName: card6["weatherName"],
                          temp: card6["weather"].toString()),

                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Additional Information",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                ),
                const SizedBox(height: 20,),
                //additional info cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HumidityCard(icon: Icons.water_drop,
                      label: "Humidity",
                      value: humidity.toString(),),
                    HumidityCard(icon: Icons.air,
                      label: "Wind Speed",
                      value: '$windSpeed Km/h',),
                    HumidityCard(icon: Icons.beach_access,
                      label: "Pressure",
                      value: pressure.toString(),),


                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
