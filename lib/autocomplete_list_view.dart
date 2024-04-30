// autocomplete_list_view.dart
import 'package:flutter/material.dart';
class AutocompleteListView extends StatelessWidget {
  final List<Map<String, dynamic>> listForPlaces;
  final Function(String) onSelectPlace;

  const AutocompleteListView({
    Key? key,
    required this.listForPlaces,
    required this.onSelectPlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Madhu = AutocompleteListView Entered");

    return ListView.builder(

      itemCount: listForPlaces.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(listForPlaces[index]['description']),
          onTap: () => onSelectPlace(listForPlaces[index]['placeId']),
        );
      },
    );
  }
}