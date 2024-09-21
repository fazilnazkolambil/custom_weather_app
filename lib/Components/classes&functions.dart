import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

IconData mapStringToIconData(String iconCode) {
  switch (iconCode) {
    case '01d':
      return WeatherIcons.day_sunny;
    case '01n':
      return WeatherIcons.night_clear;
    case '02d':
      return WeatherIcons.day_cloudy;
    case '02n':
      return WeatherIcons.night_alt_cloudy;
    case '03d':
    case '03n':
      return WeatherIcons.cloud;
    case '04d':
    case '04n':
      return WeatherIcons.cloudy;
    case '09d':
    case '09n':
      return WeatherIcons.showers;
    case '10d':
      return WeatherIcons.day_rain;
    case '10n':
      return WeatherIcons.night_alt_rain;
    case '11d':
    case '11n':
      return WeatherIcons.thunderstorm;
    case '13d':
    case '13n':
      return WeatherIcons.snow;
    case '50d':
    case '50n':
      return WeatherIcons.fog;
    default:
      return WeatherIcons.alien;
  }
}

Future <void> saveData () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
}

/// RiverPod
// BottomSheet Text Field
final changeValue = StateProvider <bool?> ((ref) => null);
final deleteItem = StateProvider <bool?> ((ref) => null);
final checkBoxprovider = StateProvider <bool?> ((ref) => null);


///Checkbox Example

class ListItem {
  String title;
  bool isSelected;

  ListItem({required this.title, this.isSelected = false});
}


class ContainerList extends StatefulWidget {
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  List<ListItem> items = [
    ListItem(title: 'Item 1'),
    ListItem(title: 'Item 2'),
    ListItem(title: 'Item 3'),
    ListItem(title: 'Item 4'),
    ListItem(title: 'Item 5'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(items[index].title),
          value: items[index].isSelected,
          onChanged: (bool? value) {
            setState(() {
              items[index].isSelected = value ?? false;
            });
          },
        );
      },
    );
  }
}

