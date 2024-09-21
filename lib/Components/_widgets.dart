import 'package:custom_weather_app/ConstPage/_constPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'classes&functions.dart';

///List tiles for (2nd tab,)

class ListTileTexts extends StatelessWidget {
  final String title;
  final String subTitle;
  const ListTileTexts({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,style: TextStyle(
        color: colorConst.secondaryColor.withOpacity(0.5)
      )),
      subtitle: Text(subTitle,style: TextStyle(
          color: colorConst.secondaryColor
      )),
    );
  }
}

///BottomSheet for (adding city,)

class BottomSheetPage extends ConsumerWidget {
  final Future <void> getCity;
  const BottomSheetPage({super.key,
    required this.getCity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController searchController = TextEditingController();
    final changed = ref.watch(changeValue) ?? false;
    return BottomSheet(
        onClosing: () {

        },
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(20),
            child : Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    if(searchController.text.isNotEmpty){
                      ref.read(changeValue.notifier).update((state) => true);
                    }else{
                      ref.read(changeValue.notifier).update((state) => false);
                    }
                  },
                  onSubmitted: (value) {

                  },
                  decoration: InputDecoration(
                    hintText: "Enter city name",
                    suffixIcon: changed?IconButton(
                        onPressed: () {
                          //FocusManager.instance.primaryFocus!.unfocus();
                        },
                        icon: Text('Done',style: TextStyle(fontWeight: FontWeight.w600))
                    ):SizedBox()
                  ),
                ),
                Center(child: Text(searchController.text))
              ],
            )
          );
        },
    );
  }
}


