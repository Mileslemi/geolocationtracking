import 'package:flutter/material.dart';
import 'package:geolocationtracking/otherusers.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Geolocation Tracking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var myLocation = "Click to get My Location";
  late bool serviceEnabled;
  late LocationPermission permission;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initiateLocation();
    });
    super.initState();
  }

  void initiateLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        myLocation = "Location services denied";
      }
    } else if (permission == LocationPermission.deniedForever) {
      myLocation = "Location services denied";
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
  }

  void getCurrentlocation() async {
    if (serviceEnabled == true) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var latitude = position.latitude;
      var longitude = position.longitude;
      setState(() {
        myLocation = "Latitude: $latitude,  longitude:$longitude";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 45,
            ),
            const Text('My Location'),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                getCurrentlocation();
              },
              child: Text(myLocation),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.cyanAccent),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OtherUser(),
                  ),
                );
              },
              child: const Text(
                "See Other Users Location",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
