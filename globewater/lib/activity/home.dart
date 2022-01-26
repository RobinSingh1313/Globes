import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}
/*
  DropdownButton(
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(), // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            )*/

class _homeState extends State<home> {
 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Razorpay razorpay;

    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];
    String dropdownvalue = 'Item 1';

    final urlimagebg = 'assets/bg.png';
    final urlimagekinley = 'assets/kinley.png';
    final starss = 'assets/stars.png';


    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            urlimagebg,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                urlimagekinley,
                height: 300,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    "15 lt Water",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 26,
                        color: Colors.black),
                  ),
                  const Text(
                    "₹15.00",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 26,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              DropdownButton(
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(), // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

}
