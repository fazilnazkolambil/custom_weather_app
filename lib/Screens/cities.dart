
import 'dart:convert';

import 'package:custom_weather_app/ConstPage/_constPage.dart';
import 'package:custom_weather_app/Screens/selectedCityWeather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

import '../Components/classes&functions.dart';
import '../main.dart';
import '../modelPage/weatherModel.dart';
import 'package:http/http.dart' as http;

class Cities extends ConsumerStatefulWidget {
  const Cities({super.key});

  @override
  ConsumerState<Cities> createState() => _CitiesState();
}



class _CitiesState extends ConsumerState<Cities> {
  List addedCities = [];
  
  TextEditingController searchController = TextEditingController();
  WeatherModel? weatherModel;
  http.Response? apiResponse;
  var weatherData;
  var apiURL;
  double? latitude;
  double? longitude;

     getCity(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        setState(() {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
          apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=${locations.first.latitude}&lon=${locations.first.longitude}&appid=313356008fea1218fac1df8fead6e57e";
        });
        apiResponse = await http.get(Uri.tryParse(apiURL)!);

        if(apiResponse != null){
          setState(() {
            weatherData = json.decode(apiResponse!.body);
            //weatherModel = WeatherModel.fromJson(weatherData);
          });
        }
      }
    } catch (e) {
      print("-----Catch error------: $e");
    }
  }

  Future <void> saveData() async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       String jsonString = json.encode(addedCities);
       prefs.setString("addedCities", jsonString);
}
  Future <void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('addedCities');
    if(jsonString != null){
      setState(() {
        addedCities = json.decode(jsonString);
      });
    }
  }

  @override
  void initState() {
    getCity(searchController.text);
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final  changed = ref.watch(changeValue) ?? false;
    final  delete = ref.watch(deleteItem) ?? false;
    final  checkBox = ref.watch(checkBoxprovider) ?? false;
    return Scaffold(
      backgroundColor: colorConst.primaryColor,
      appBar: AppBar(
        backgroundColor: colorConst.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
            child: CircleAvatar(
              backgroundColor: colorConst.primaryColor,
                child: Icon(CupertinoIcons.back,color: colorConst.secondaryColor.withOpacity(0.5)))),
        title: Text('Select City',style: TextStyle(
            color: colorConst.secondaryColor
        )),
        actions: [
          delete?
              TextButton(
                  onPressed: () {
                    ref.read(deleteItem.notifier).update((state) => false);
                    ref.read(checkBoxprovider.notifier).update((state) => false);
                    for(int i = 0; i < addedCities.length; i ++){
                      if(addedCities[i]['isSelected'] == true){
                        addedCities[i]['isSelected'] = false;
                      }else{
                        
                      }
                    }
                  },
                  child: Text("Cancel",style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorConst.secondaryColor
                  ),))
              :SizedBox()
        ],
      ),
      body: Padding(
        padding:EdgeInsets.all(width*0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: searchController,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  getCity(searchController.text);
                  if(searchController.text.isNotEmpty){
                    ref.read(changeValue.notifier).update((state) => true);
                  }else{
                    ref.read(changeValue.notifier).update((state) => false);
                  }
                },
                onSubmitted: (value) {
                  getCity(searchController.text);
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                style: TextStyle(
                  color: colorConst.secondaryColor.withOpacity(0.5)
                ),
                decoration: InputDecoration(
                    hintText: "Enter city name",
                    hintStyle: TextStyle(
                      color: colorConst.secondaryColor.withOpacity(0.5)
                    ),
                    suffixIcon: changed?IconButton(
                        onPressed: () {
                          getCity(searchController.text);
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        icon: Text('Done',style: TextStyle(
                            fontWeight: FontWeight.w600,
                          color:colorConst.secondaryColor
                        ))
                    ):SizedBox()
                ),
              ),
              SizedBox(height: 30,),
              changed?

                  ///Search field

              SizedBox(
                child: Center(
                  child: latitude != null && longitude != null && weatherData != null?
                  InkWell(
                    onTap: () {
                      addedCities.add({
                        "data" : weatherData,
                        "isSelected" : false
                      });
                      ref.read(changeValue.notifier).update((state) => false);
                      FocusManager.instance.primaryFocus!.unfocus();
                      searchController.clear();
                      saveData();
                    },
                    child:
                    SizedBox(
                      height: width*0.2,
                      width: width*0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(searchController.text,style: TextStyle(
                              color: colorConst.secondaryColor,
                              fontSize: width*0.05,
                              fontWeight: FontWeight.w500
                          ),),
                          Text('${((weatherData['main']['temp']) - 273.15).toString().substring(0,2)} °C',style: TextStyle(
                            color: colorConst.secondaryColor,
                            fontSize: width*0.05,
                          )),
                        ],
                      ),
                    ),
                  )
                : CircularProgressIndicator(color: colorConst.secondaryColor,),
                ),
              ):

                  ///List of Cities

              SizedBox(
                height: height*0.7,
                child: ListView.separated(
                  itemCount: addedCities.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        ref.read(deleteItem.notifier).update((state) => true);
                      },
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CityWeather(weatherData: addedCities[index]['data']),));
                      },
                      child: SizedBox(
                        height: width*0.2,
                        width: width*1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [

                                    SizedBox(
                                      width: 30,
                                      child: delete?
                                      Checkbox(
                                          value: addedCities[index]['isSelected'],
                                          onChanged: (value) {
                                            ref.read(checkBoxprovider.notifier).update((state) =>true);
                                            addedCities[index]['isSelected'] = value;
                                            setState(() {

                                            });
                                          },
                                      ):
                                      Text('${index + 1} - ',style: TextStyle(
                                        color: colorConst.secondaryColor.withOpacity(0.5),
                                        fontSize: width*0.04,
                                      )),
                                    ),
                                SizedBox(width: 20,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(addedCities[index]['data']['name'],style: TextStyle(
                                        color: colorConst.secondaryColor,
                                        fontSize: width*0.05,
                                        fontWeight: FontWeight.w500
                                    ),),
                                    Text('${((addedCities[index]['data']['main']['temp']) - 273.15).toString().substring(0,2)} °C',style: TextStyle(
                                      color: colorConst.secondaryColor.withOpacity(0.5),
                                      fontSize: width*0.04,
                                    )),
                                    Text('${addedCities[index]['data']['weather'][0]['main']}',style: TextStyle(
                                      color: colorConst.secondaryColor.withOpacity(0.5),
                                      fontSize: width*0.03,
                                    ))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                                height: width*0.3,
                                width: width*0.3,
                                child: BoxedIcon(mapStringToIconData(addedCities[index]['data']['weather'][0]['icon']),
                                  color: colorConst.secondaryColor,
                                  size: width*0.1,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: width*0.1,)
                ),
              )
            ],
          ),
        ),
      ),
        bottomNavigationBar: checkBox?
        InkWell(
          onTap: () {
            showAdaptiveDialog(context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Remove?'),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(child: Text("No"),),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            addedCities.removeWhere((element) => element['isSelected'] == true);
                            ref.read(deleteItem.notifier).update((state) => false);
                            ref.read(checkBoxprovider.notifier).update((state) => false);
                            Navigator.pop(context);
                            saveData();
                            setState(() {

                            });
                          },
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(child: Text("Yes"),),
                          ),
                        ),
                      ],
                    ),
                  );
                });
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
              child: Icon(CupertinoIcons.delete_simple,color: Colors.red,),
            ),
          ),
        ):SizedBox()
    );
  }
}

///Finding Lat & long of a Location

// class CityLocator extends StatefulWidget {
//   @override
//   _CityLocatorState createState() => _CityLocatorState();
// }
//
// class _CityLocatorState extends State<CityLocator> {
//   String cityName = "";
//   double? latitude;
//   double? longitude;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCityCoordinates(cityName);
//   }
//
//   Future<void> _getCityCoordinates(String cityName) async {
//     try {
//       List<Location> locations = await locationFromAddress(cityName);
//       if (locations.isNotEmpty) {
//         setState(() {
//           latitude = locations.first.latitude;
//           longitude = locations.first.longitude;
//         });
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("City Locator"),
//         ),
//         body: Center(
//             child: latitude != null && longitude != null
//                 ? Text("City: $cityName\nLatitude: $latitude\nLongitude: $longitude")
//                 : CircularProgressIndicator(),
//             ),
//         );
//   }
// }


