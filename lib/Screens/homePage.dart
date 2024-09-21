import 'dart:convert';

import 'package:custom_weather_app/Components/_widgets.dart';
import 'package:custom_weather_app/ConstPage/_constPage.dart';
import 'package:custom_weather_app/Screens/cities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import '../Components/classes&functions.dart';
import '../main.dart';
import '../modelPage/weatherModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherModel;
  http.Response? apiResponse;
  var weatherData;
  var apiURL;
  getLocation () async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      Future.error('Location permissions are denied');
      LocationPermission ask = await Geolocator.requestPermission();
    }
  }

  String? address;
  // double? latitude;
  // double? longitude;

  getAddress () async {
    try{
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      List <Placemark> result = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);
      Placemark first = result.first;
      setState(() {
        address = "${first.locality}";
        apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&appid=313356008fea1218fac1df8fead6e57e";
      });
      apiResponse = await http.get(Uri.tryParse(apiURL)!);
      weatherData = json.decode(apiResponse!.body);
      if(apiResponse != null){
        weatherModel = WeatherModel.fromJson(weatherData);
        setState(() {

        });
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load your Location")));
    }
  }

  @override
  void initState() {
    getAddress();
    //getApi();
    getLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      weatherModel == null?
    Scaffold(
      backgroundColor: colorConst.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorConst.secondaryColor,
            ),
            SizedBox(height: width*0.08),
            Text("syncing...",style: TextStyle(
              color: colorConst.secondaryColor.withOpacity(0.5)
            ),)
          ]),
      ),
    ):
    DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: colorConst.primaryColor,
          appBar: AppBar(
            backgroundColor: colorConst.primaryColor,
            leadingWidth: width*0.5,
            leading: Padding(
              padding:EdgeInsets.symmetric(horizontal: width*0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(//weatherModel!.name,
                    address.toString(),
                      style: TextStyle(
                      fontSize: width*0.05,
                      color:colorConst.secondaryColor
                  )),
                  Text('Current Location',style: TextStyle(
                      fontSize: width*0.03,
                      color:colorConst.textColor
                  ))
                ],
              ),
            ),
          ),
          body: TabBarView(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await getAddress();
                  },
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: height*0.85,
                      width: width*1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ElevatedButton(onPressed: () {
                          //   getAddress();
                          // },
                          //     child: Text("data")),
                          Text(DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(weatherModel!.dt * 1000)),style: TextStyle(
                              fontSize: width*0.03,
                              color: colorConst.secondaryColor.withOpacity(0.5)
                          )),
                          SizedBox(
                            height: width*0.25,
                            width: width*1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(((weatherModel!.main.temp) - 273.15 ).toString().substring(0,2),style: TextStyle(
                                  fontSize: width*0.2,
                                  color: colorConst.secondaryColor,
                                )),
                                Text('°C',style: TextStyle(
                                  fontSize: width*0.1,
                                  color: colorConst.secondaryColor,
                                ))
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.down_arrow,color: colorConst.secondaryColor.withOpacity(0.5),),
                                    Text('${((weatherModel!.main.tempMin) - 273.15 ).toString().substring(0,2)} °C',style:
                                    TextStyle(
                                        color: colorConst.secondaryColor.withOpacity(0.5)
                                    ),),
                                  ],
                                ),
                                SizedBox(width: 30,),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.up_arrow,color: colorConst.secondaryColor.withOpacity(0.5)),
                                    Text('${((weatherModel!.main.tempMax) - 273.15 ).toString().substring(0,2)} °C',style:
                                    TextStyle(
                                        color: colorConst.secondaryColor.withOpacity(0.5)
                                    ),),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: width*0.5,
                            child:
                            BoxedIcon(mapStringToIconData('${weatherModel!.weather[0].icon}'),
                              color: colorConst.secondaryColor,
                              size: width*0.4,
                            ),
                            //SvgPicture.asset(iconConst.overcastCloud,color: colorConst.secondaryColor,)
                            //Image(image: AssetImage(imageConst.overcastCloud),color: colorConst.secondaryColor,fit: BoxFit.fill,)
                          ),
                          Text(weatherModel!.weather[0].main,style: TextStyle(
                              color: colorConst.secondaryColor.withOpacity(0.5),
                              fontSize: width*0.05
                          ),),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.sunrise,color: colorConst.secondaryColor.withOpacity(0.5),),
                                    Text('${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(weatherModel!.sys.sunrise*1000))}',
                                      style: TextStyle(
                                          color: colorConst.secondaryColor.withOpacity(0.5)
                                      ),),
                                  ],
                                ),
                                SizedBox(width:30,),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.sunset,color: colorConst.secondaryColor.withOpacity(0.5)),
                                    Text('${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(weatherModel!.sys.sunset*1000))}',style:
                                    TextStyle(
                                        color: colorConst.secondaryColor.withOpacity(0.5)
                                    ),),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height*0.9,
                  width: width*1,
                  child: Padding(
                    padding: EdgeInsets.all(width*0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Details',style: TextStyle(
                            fontSize: width*0.06,
                            fontWeight: FontWeight.w500,
                            color: colorConst.secondaryColor
                        )),
                        ListTileTexts(
                            title: "Feels Like",
                            subTitle: '${((weatherModel!.main.feelsLike) - 273.15).toString().substring(0,2)} °C'
                        ),
                        ListTileTexts(
                            title: "SE Wind",
                            subTitle: '${(((weatherModel!.wind.speed) * 3600) / 1000).toString()} km/h'
                        ),
                        ListTileTexts(
                            title: "Humidity",
                            subTitle: '${weatherModel!.main.humidity.toString()} %'
                        ),
                        ListTileTexts(
                            title: "Visibility",
                            subTitle: '${((weatherModel!.visibility) / 1000).toString()} km'
                        ),
                        ListTileTexts(
                            title: "pressure",
                            subTitle: '${weatherModel!.main.pressure.toString()} hPa'
                        ),
                      ],
                    ),
                  ),
                )

              ]
          ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Cities()));
          },
          child: Container(
            height: 50,
            width: width*1,
            decoration: BoxDecoration(
              color: colorConst.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: colorConst.secondaryColor.withOpacity(0.2),
                  offset: Offset(0, 2),
                  spreadRadius: 5,
                  blurRadius: 25
                ),
              ]
            ),
            child: Center(
              child: SvgPicture.asset(iconConst.location),
            ),
          ),
        )

      ),
    );
  }
}
