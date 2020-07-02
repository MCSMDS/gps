import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gpsapi/gpsapi.dart';

void main() => runApp(MaterialApp(home: CurrentLocationWidget()));

class CurrentLocationWidget extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  List<GpsLatlng> positions = <GpsLatlng>[];
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
    GpsLatlng newposition = await Gps.currentGps();
    if (positions.length != 0 &&
        positions.last.longitude == newposition.longitude &&
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

  Future checkPermission() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS'),
      ),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (positions.length == 0)
            return Center(child: CircularProgressIndicator());
          return _buildLocation();
        },
      ),
    );
  }

  Widget _buildLocation() {
    List<Widget> item = <Widget>[];
    item.addAll(positions.map((GpsLatlng position) {
      return ListTile(
        title: Column(
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
    return "${du.toString()}°${feng.toString()}'${miao.toStringAsFixed(1)}\"";
  }
}
