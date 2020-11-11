import 'package:flutter/material.dart';
import 'package:json_http_test/WeatherBloc.dart';
import 'package:json_http_test/WeatherModel.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_http_test/WeatherRepo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueAccent[200],
          body: BlocProvider(
            builder: (context) => WeatherBloc(WeatherRepo()),
            child: SearchPage(),
          ),
        ));
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
            child: Container(
          child: FlareActor(
            "assets/Minion.flr",
            fit: BoxFit.fill,
            animation: "Wave",
          ),
          height: 360,
          width: 700,
        )),
        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherIsNotSearched)
              return Container(
                padding: EdgeInsets.only(
                  left: 32,
                  right: 32,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Excursión con",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.yellow[900]),
                    ),
                    Text(
                      "¡LOS MINIONS!",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.yellowAccent),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.add_location_rounded,
                          color: Colors.black12,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                                color: Colors.yellow[800],
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.yellow,
                                style: BorderStyle.solid)),
                        hintText: "Nombre de la ciudad",
                        hintStyle: TextStyle(color: Colors.yellow),
                      ),
                      style: TextStyle(color: Colors.yellowAccent[100]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                        color: Colors.yellowAccent[100],
                        child: Text(
                          "Buscar",
                          style: TextStyle(
                              color: Colors.yellow[800], fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              );
            else if (state is WeatherIsLoading)
              return Center(child: CircularProgressIndicator());
            else if (state is WeatherIsLoaded)
              return ShowWeather(state.getWeather, cityController.text);
            else
              return Container(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: () {
                    FlareActor(
                      "assets/Minion.flr",
                      fit: BoxFit.fill,
                      animation: "Wave",
                    );
                  },
                  color: Colors.yellowAccent[100],
                  child: Text(
                    "Buscar otra Ciudad",
                    style: TextStyle(color: Colors.yellow[800], fontSize: 20),
                  ),
                ),
              );
          },
        )
      ],
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
            Text(
              city,
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              weather.getTemp.round().toString() + "º",
              style: TextStyle(color: Colors.redAccent, fontSize: 50),
            ),
            Text(
              "Temperatura",
              style: TextStyle(color: Colors.amber, fontSize: 25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      weather.getpressure.round().toString() + "PA",
                      style: TextStyle(color: Colors.redAccent, fontSize: 30),
                    ),
                    Text(
                      "Presión",
                      style: TextStyle(color: Colors.blue[100], fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      weather.gethumidity.round().toString() + "%",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 30),
                    ),
                    Text(
                      "Humedad",
                      style: TextStyle(color: Colors.blue[300], fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                },
                color: Colors.yellowAccent[100],
                child: Text(
                  "¡Buscar Otra Ciudad!",
                  style: TextStyle(color: Colors.yellow[800], fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}
