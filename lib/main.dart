import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gps/gps.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MaterialApp(home: CurrentLocationWidget()));

class CurrentLocationWidget extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  List<Map> positions = <Map>[];
  Timer timer;

  @override
  void initState() {
    addtLocation();
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      addtLocation();
    });
    super.initState();
  }

  addtLocation() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    Position newposition1 = await geolocator.getCurrentPosition();
    GpsLatlng newposition2 = await Gps.currentGps();
    Map<String, dynamic> position = {
      'longitude': double.parse(newposition2.lng),
      'latitude': double.parse(newposition2.lat),
      'altitude': newposition1.altitude,
      'timestamp': newposition1.timestamp,
    };
    if (positions.length != 0 &&
        positions.last['longitude'] == position['longitude'] &&
        positions.last['latitude'] == position['latitude'] &&
        positions.last['altitude'] == position['altitude']) return;
    setState(() => positions.add(position));
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  Future<GeolocationStatus> checkPermission() {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    return geolocator.checkGeolocationPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS'),
      ),
      body: FutureBuilder<GeolocationStatus>(
        future: checkPermission(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData || positions.length == 0)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data == GeolocationStatus.denied)
            return Center(child: Text('请允许此应用程序访问位置。'));

          return _buildLocation();
        },
      ),
    );
  }

  Widget _buildLocation() {
    List<Widget> item = <Widget>[];
    item.addAll(positions.map((Map position) {
      return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('经度: ${dd2dms(position['longitude'])}'),
            Text('纬度: ${dd2dms(position['latitude'])}'),
            Text('海拔: ${position['altitude']}'),
            Text('时间: ${position['timestamp'].toLocal().toString()}'),
          ],
        ),
      );
    }).toList());
    return ListView(children: item);
  }

  String dd2dms(double number) {
    int du = number.toInt();
    int feng = ((number - du) * 60).toInt();
    double miao = (((number - du) * 60 - feng) * 60);
    return "${du.toString()}°${feng.toString()}'${miao.toStringAsFixed(1)}\"";
  }
}
