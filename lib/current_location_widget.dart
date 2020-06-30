import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'placeholder_widget.dart';

class CurrentLocationWidget extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  String _currentPosition;

  @override
  void initState() {
    _initCurrentLocation();
    super.initState();
  }

  _initCurrentLocation() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    Position position = await geolocator.getCurrentPosition();
    String locate = position.toString();
    if (mounted) {
      setState(() => _currentPosition = locate);
    }
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
            return PlaceholderWidget('拒绝访问位置', '允许使用设备设置访问此应用的位置服务。');
          }

          return Center(
            child: PlaceholderWidget('当前位置：', _currentPosition),
          );
        },
      ),
    );
  }
}
