import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'placeholder_widget.dart';

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
    LocationOptions option =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    Stream<Position> stream = geolocator.getPositionStream(option);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS'),
      ),
      body: FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return PlaceholderWidget('位置服务已禁用', '使用设备设置为此应用启用位置服务。');
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
              Text('${position.latitude}'),
              Text('${position.longitude}'),
              Text('${position.timestamp.toLocal().toString()}'),
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
