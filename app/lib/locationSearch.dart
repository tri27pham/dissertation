import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class LocationSearch extends StatefulWidget {
  // const LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final TextEditingController _locationController = TextEditingController();

  String sessionToken = '89025';

  var uuid = Uuid();

  List<dynamic> places = [];

  void makeSuggestion(String input) async {
    String apiKey = 'AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294';
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$url?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    var responseData = response.body.toString();

    print("test");
    print(responseData);
    print("test");

    if (response.statusCode == 200) {
      setState(() {
        places = jsonDecode(responseData)['predictions'];
      });
    } else {
      throw Exception('FAILED');
    }
  }

  void onModify() {
    if (_locationController.text.isEmpty) {
      setState(() {
        places.clear(); // Empty the places list
      });
      return; // Exit the method early if the controller is empty
    }
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    makeSuggestion(_locationController.text);
  }

  @override
  void initState() {
    super.initState();
    _locationController.addListener(() {
      onModify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
                borderRadius:
                    BorderRadius.circular(5), // Adjust the radius as needed
              ),
              child: TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: "enter location",
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            )),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.75,
              child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height *
                          0.05, // Specify the desired height
                      width:
                          MediaQuery.of(context).size.width, // Use full width
                      child: ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              places[index]['description']);
                          print(locations.last.longitude);
                          print(locations.last.latitude);
                        },
                        title: Text(places[index]['description']),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
