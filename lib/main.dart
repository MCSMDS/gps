import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MaterialApp(home: LocationStreamWidget()));

class LocationStreamWidget extends StatefulWidget {
  @override
  State<LocationStreamWidget> createState() => LocationStreamState();
}

class LocationStreamState extends State<LocationStreamWidget> {
  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = <Position>[];

  @override
  void initState() {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    Stream<Position> stream = geolocator.getPositionStream();
    _positionStreamSubscription = stream.listen(
        (Position position) => setState(() => _positions.add(position)));
    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _positionStreamSubscription = null;
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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return Text('请允许此应用程序访问位置。');
          }

          return _buildListView();
        },
      ),
    );
  }

  Widget _buildListView() {
    List<Widget> listItems = <Widget>[];
    listItems.addAll(_positions.map(
      (Position position) {
        return ListTile(
          title: Column(
            children: <Widget>[
              Text('纬度: ${position.latitude}'),
              Text('经度: ${position.longitude}'),
              Text('时间: ${position.timestamp.toLocal().toString()}'),
            ],
          ),
        );
      },
    ).toList());
    return ListView(
      children: listItems,
    );
  }
}
