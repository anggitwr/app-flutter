import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

class AaScreen extends StatefulWidget {
  const AaScreen({super.key});

  @override
  State<AaScreen> createState() => _AaScreenState();
}

class _AaScreenState extends State<AaScreen> {

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  var _battery = Battery();
  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  int _batteryLevel = 0;
  late Timer timer;
  bool? _isInPowerSaveMode;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  List<double>? _accelerometerVls;

  List<double>? _gyroscopeVls;

  List<double>? _magnetVls;
  @override
  Widget build(BuildContext context) {

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      //battery state will be listen here
      setState(() {
        _batteryState = state;
      });
    });

    final accelerometer =
    _accelerometerVls?.map((double v) => v.toStringAsFixed(1)).toList();

    final gyroscope =
    _gyroscopeVls?.map((double v) => v.toStringAsFixed(1)).toList();

    final magnetometer =
    _magnetVls?.map((double v) => v.toStringAsFixed(1)).toList();

    DateTime dateTime = DateTime.now();
    String datetime = DateFormat.Hm().format(dateTime);
    print(datetime);

    String datetime2 = DateFormat.MMMMEEEEd().format(dateTime);
    print(datetime2);

    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman A"),
      ),
      body: Column(
          children: [
            Text(datetime),
            Text(datetime2),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Accelerometer: $accelerometer')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Gyroscope: $gyroscope'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Magnetometer: $magnetometer'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Battery Status: $_batteryState', style: const TextStyle(fontSize: 18),),
                  Text('Battery Level%: $_batteryLevel %', style: const TextStyle(fontSize: 18)),
                  Text("Mode daya rendah: $_isInPowerSaveMode", style: const TextStyle(fontSize: 18) )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(servicestatus? "GPS is Aktif": "GPS is Tidak aktif."),
                  Text(haspermission? "GPS is Aktif": "GPS is Tidak aktif."),

                  Text("Longitude: $long", style:TextStyle(fontSize: 20)),
                  Text("Latitude: $lat", style: TextStyle(fontSize: 20),)
                ],
              ),
            ),
          ],
      ),
    );
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Tidak On, Aktifkan GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude);
    print(position.latitude);

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {

    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude);
      print(position.latitude);

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {

      });
    });
  }


  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }
  void getBatteryState() {
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
          setState(() {
            _batteryState = state;
          });
        });
  }

  getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }
  Future<void> checkBatterSaveMode() async {
    final isInPowerSaveMode = await _battery.isInBatterySaveMode;
    setState(() {
      _isInPowerSaveMode = isInPowerSaveMode;
    });
  }


  @override
  void initState() {
    super.initState();
    checkGps();
    getBatteryState();
    checkBatterSaveMode();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryLevel();
    });

    _streamSubscriptions.add(
      accelerometerEvents.listen(
            (AccelerometerEvent event) {
          setState(() {
            _accelerometerVls = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
            (GyroscopeEvent event) {
          setState(() {
            _gyroscopeVls = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
            (MagnetometerEvent event) {
          setState(() {
            _magnetVls = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }
}
