import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'placeholder_widget.dart';

class CurrentLocationWidget2 extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget2> {
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _currentPosition = null;
    });
    _initCurrentLocation();
  }

  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = true
      ..getCurrentPosition().then((position) {
        setState(() => _currentPosition = position);
      });
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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return PlaceholderWidget('拒绝访问位置', '允许使用设备设置访问此应用的位置服务。');
          }

          return Center(
            child: PlaceholderWidget('当前位置：', _currentPosition.toString()),
          );
        },
      ),
    );
  }
}
