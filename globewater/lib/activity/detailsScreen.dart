import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:globewater/activity/body.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#14446D"),
        appBar: AppBar(
          backgroundColor: HexColor("#14446D"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          //    leading: Icon(Icons.arrow_back)),
        ),body: Body(),
        );
  }
}
