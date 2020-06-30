import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../common_widgets/placeholder_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('地理定位器示例应用程序'),
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
    listItems.addAll(_positions
        .map((Position position) => ListTile(
            title: Text(
                '${position.latitude} ${position.longitude} ${position.timestamp.toLocal().toString()}')))
        .toList());
    return ListView(
      children: listItems,
    );
  }
}
