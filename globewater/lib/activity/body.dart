import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var _razorpay = Razorpay();
  String Address = 'Click Location';

  String dropdownvalue = 'Select Any Floor';

  var items = [
    'Select Any Floor',
    'Ground Floor',
    'First Floor',
    'Second Floor',
    'Other'
  ];

  var _counter = 1;
  var whichfloor;
  var mobilenumber = "9014473447";
  late DatabaseReference _databaseReference, _anotherdatabaseReference;
  var currentday;
  double latitudes = 0.0, longitudes = 0.0;

  var currentmonth;
  var k;
  var now = new DateTime.now();
  List<String> result = [];
  List<String> datess = [];
  var _selected = "";
  void increment() {
    setState(() {
      _counter++;
    });
  }

  void decremenent() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
    });
  }

  var options = {
    'key': 'rzp_test_CQvve50jQO7JHM',
    'amount': 100,
    'name': 'Acme Corp.',
    'description': 'Fine T-Shirt',
    'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
  };
  @override
  void initState() {
    // TODO: implement initState
    _databaseReference =
        FirebaseDatabase.instance.ref().child("UserBookRequest");
    _databaseReference =
        FirebaseDatabase.instance.ref().child("UserBookedRequest");

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    BookOrder("Online");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var locationaddress = "";
    String Addr = "";
    String _chosenValue = "Select a Floor";

    String location = 'Null, Press Button';
    DateTime selectedDate = DateTime.now();

    currentday = selectedDate.day;
    currentmonth = selectedDate.month;
    if (currentmonth >= 10) {
      k = currentday.toString() + "-" + currentmonth.toString();
    } else {
      k = currentday.toString() + "-0" + currentmonth.toString();
    }

//payment ateway

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
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
      setState(() {});
    }

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
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
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
                              const SizedBox(
                                width: 10,
                              ),
                              DropdownButton(
                                value: dropdownvalue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                      value: items, child: Text(items));
                                }).toList(),
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
                                      onPressed: () => increment())),
                              const SizedBox(
                                width: 10,
                              ),

                              Text(
                                _counter.toString(),
                                style: TextStyle(fontSize: 22),
                              ),
                              const SizedBox(
                                width: 10,
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
                                      onPressed: () => decremenent())),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              '${Address}',
                              style: TextStyle(
                                  color: HexColor("#14446D"),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Delivery Location"),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: HexColor("#14446D")),
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.location_searching_sharp,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    Position position =
                                        await _getGeoLocationPosition();
                                    location =
                                        'Lat: ${position.latitude} , Long: ${position.longitude}';
                                    GetAddressFromLatLong(position);
                                  })),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                _displayDialog(context);
                              },
                              child: const Text(
                                "Buy Now",
                                style: TextStyle(
                                    fontSize: 25, fontFamily: 'Montserrat'),
                              ))
                        ],
                      ),
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

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    var list = dateRangePickerSelectionChangedArgs.value.toString();
    result = list.split(',');

    Fluttertoast.showToast(
        msg: "P" + result.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    print(list);
  }
  //dialog box method

  _displayDialog(BuildContext context) async {
    _selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: SimpleDialog(
            title: Text('Select Days'),
            children: [
              SimpleDialogOption(
                  child: Container(
                width: 250,
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  selectionColor: HexColor('#14446D'),
                ),
              )),
              SimpleDialogOption(
                child: ElevatedButton(
                    onPressed: () => selectDays(), child: Text("Select Days")),
              ),
              SimpleDialogOption(
                child: Text(
                  "Booking Days:" + datess.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SimpleDialogOption(
                child: ElevatedButton(
                    onPressed: () => _razorpay.open(options),
                    child: Text("Pay Now")),
              )
            ],
            elevation: 10,
            //backgroundColor: Colors.green,
          ),
        );
      },
    );

    if (_selected != null) {
      setState(() {
        _selected = _selected;
      });
    }
  }

  selectDays() {
    datess.clear();

    Fluttertoast.showToast(
        msg: "P" + result.length.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    for (var i = 0; i < result.length; i++) {
      var check = result[i].substring(9, 11) + "-" + result[i].substring(6, 8);
      var dateofbooks = result[i].substring(9, 11);
      int dateofbookss = int.parse(dateofbooks);
      var bookofmonth = result[i].substring(6, 8);
      int bookofmonths = int.parse(bookofmonth);
      print(bookofmonths.runtimeType);
      print(dateofbookss.runtimeType);
      print(currentmonth.runtimeType);
      print(currentday.runtimeType);

      if (currentmonth >= bookofmonths) {
        if (dateofbookss >= currentday) {
          datess.add(check);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Sorry U cannot book past days",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    Fluttertoast.showToast(
        msg: "Bookin Days:" + datess.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    print("hello" + datess.toString());
  }

  void BookOrder(String paymentType) {
    for (int i = 0; i < datess.length; i++) {
      Map<String, String> booking = {
        'Delivery': 'false',
        'days': datess[i].toString(), //add
        'floor': whichfloor,
        'latitude': latitudes.toString(),
        'longitude': longitudes.toString(),
        'paymentmode': paymentType,
        'quantitys': _counter.toString(),
        'total': '15',
        'uid': mobilenumber
      };
      Fluttertoast.showToast(
          msg: "Method Work:",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(
          msg: _databaseReference.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      _databaseReference.child(datess[i]).child(mobilenumber).set(booking);
    }
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