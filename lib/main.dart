import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MaterialApp(home: CurrentLocationWidget()));

class CurrentLocationWidget extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  List<Position> positions = <Position>[];
  Timer timer;

  @override
  void initState() {
    addtLocation();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      addtLocation();
    });
    super.initState();
  }

  void addtLocation() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    Position newposition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    if (positions.last.longitude == newposition.longitude &&
        positions.last.latitude == newposition.latitude &&
        positions.last.altitude == newposition.altitude) return;
    setState(() => positions.add(newposition));
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
        title: Text('GPS'),
      ),
      body: FutureBuilder<GeolocationStatus>(
        future: checkPermission(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData || positions.length == 0)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data == GeolocationStatus.denied)
            return Text('请允许此应用程序访问位置。');

          return _buildLocation();
        },
      ),
    );
  }

  Widget _buildLocation() {
    List<Widget> item = <Widget>[];
    item.addAll(positions.map((Position position) {
      return ListTile(
        title: Row(
          children: <Widget>[
            Text('经度: ${dd2dms(position.longitude)}'),
            Text('纬度: ${dd2dms(position.latitude)}'),
            Text('海拔: ${position.altitude}'),
            Text('时间: ${position.timestamp.toLocal().toString()}'),
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
    return "${du.toString()}° ${feng.toString()}' ${miao.toStringAsFixed(1)}''";
  }
}
