import 'package:custom_weather_app/ConstPage/_constPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import '../Components/_widgets.dart';
import '../Components/classes&functions.dart';
import '../main.dart';
import 'cities.dart';

class CityWeather extends StatefulWidget {
  final Map weatherData;
  const CityWeather({super.key, required this.weatherData});

  @override
  State<CityWeather> createState() => _CityWeatherState();
}

class _CityWeatherState extends State<CityWeather> {
  @override
  Widget build(BuildContext context) {
    return widget.weatherData.isEmpty?
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
                      widget.weatherData['name'],
                      style: TextStyle(
                          fontSize: width*0.05,
                          color:colorConst.secondaryColor
                      )),
                  Text(widget.weatherData['sys']['country'],style: TextStyle(
                      fontSize: width*0.03,
                      color:colorConst.textColor
                  ))
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Back",style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colorConst.secondaryColor
                  ))),
            ],
          ),
          body: TabBarView(
              children: [
                RefreshIndicator(
                  onRefresh: () async {},
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: height*0.9,
                      width: width*1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(widget.weatherData['dt'] * 1000)),style: TextStyle(
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
                                Text(((widget.weatherData['main']['temp']) - 273.15 ).toString().substring(0,2),style: TextStyle(
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
                                    Text('${((widget.weatherData['main']['temp_min']) - 273.15).toString().substring(0,2)} °C',style:
                                    TextStyle(
                                        color: colorConst.secondaryColor.withOpacity(0.5)
                                    ),),
                                  ],
                                ),
                                SizedBox(width: 20,),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.up_arrow,color: colorConst.secondaryColor.withOpacity(0.5)),
                                    Text('${((widget.weatherData['main']['temp_max']) - 273.15).toString().substring(0,2)} °C',style:
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
                            BoxedIcon(mapStringToIconData('${widget.weatherData['weather'][0]['icon']}'),
                              color: colorConst.secondaryColor,
                              size: width*0.4,
                            ),
                            //SvgPicture.asset(iconConst.overcastCloud,color: colorConst.secondaryColor,)
                            //Image(image: AssetImage(imageConst.overcastCloud),color: colorConst.secondaryColor,fit: BoxFit.fill,)
                          ),
                          Text(widget.weatherData['weather'][0]['main'],style: TextStyle(
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
                                    Text('${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(widget.weatherData['sys']['sunrise']*1000))}',
                                      style: TextStyle(
                                          color: colorConst.secondaryColor.withOpacity(0.5)
                                      ),),
                                  ],
                                ),
                                SizedBox(width: 20,),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.sunset,color: colorConst.secondaryColor.withOpacity(0.5)),
                                    Text('${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(widget.weatherData['sys']['sunset']*1000))}',style:
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
                            subTitle: '${((widget.weatherData['main']['feels_like']) - 273.15).toString().substring(0,2)} °C'
                        ),
                        ListTileTexts(
                            title: "SE Wind",
                            subTitle: '${(((widget.weatherData['wind']['speed']) * 3600) / 1000).toString()} km/h'
                        ),
                        ListTileTexts(
                            title: "Humidity",
                            subTitle: '${widget.weatherData['main']['humidity'].toString()} %'
                        ),
                        ListTileTexts(
                            title: "Visibility",
                            subTitle: '${((widget.weatherData['visibility']) / 1000).toString()} km'
                        ),
                        ListTileTexts(
                            title: "pressure",
                            subTitle: '${widget.weatherData['main']['pressure'].toString()} hPa'
                        ),
                      ],
                    ),
                  ),
                )

              ]
          )

      ),
    );
  }
}
