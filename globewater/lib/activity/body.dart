import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:geolocator/geolocator.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String dropdownvalue = 'Select any Floor';
    var locationaddress = "";
    String location = 'Null, Press Button';
    String Address = 'search';
    Future<Position> _getGeoLocationPosition() async {
      bool serviceEnabled;
      LocationPermission permission;
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    Future<void> GetAddressFromLatLong(Position position) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    }

    // List of items in our dropdown menu
    var items = [
      'Select any Floor',
      'Ground Floor',
      'First Fllor',
      'Second Floor',
      'Other ',
    ];
    final urlimagekinley = 'assets/kinley.png';
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  height: 500,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              "15lt Mineral  Water",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            Text(
                              "₹15.00",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              style: TextStyle(height: 1.5),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              //dropdown
                              DropdownButton(
                                // Initial Value
                                value: dropdownvalue,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),

                              //incdec
                              Expanded(child: Container()),
                              Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: HexColor("#14446D")),
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => null)),
                              const SizedBox(
                                width: 30,
                              ),
                              Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: HexColor("#14446D")),
                                  child: IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => null))
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: const [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              "Sanareddy 502001,Netaji Nagar",
                              style: TextStyle(
                                  color: Color(0xFF42A5F5),
                                  fontSize: 15,
                                  fontFamily: 'Montserrat'),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                Position position =
                                    await _getGeoLocationPosition();
                                location =
                                    'Lat: ${position.latitude} , Long: ${position.longitude}';
                                GetAddressFromLatLong(position);
                              },
                              child: const Text(
                                "Buy Now",
                                style: TextStyle(
                                    fontSize: 25, fontFamily: 'Montserrat'),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      urlimagekinley,
                      height: 250,
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
  fetchLocation() async {}
  Future<List<Address>> getAddress(double lat, double lang) async {}
  }


  

Column(
                  children: [
                    Text(
                      "20lt Mineral Water",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: "Price\n"),
                              TextSpan(
                                  text: "\$ 15.00",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Expanded(
                            child: Image.asset(
                          urlimagekinley,
                          width: 100,
                          height: 300,
                        ))
                      ],
                    )
                  ],
                )
*/