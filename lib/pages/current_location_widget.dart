import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../common_widgets/placeholder_widget.dart';

class CurrentLocationWidget extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  Position _currentPosition;

  @override
  void initState() {
    _initCurrentLocation();
    super.initState();
  }

  _initCurrentLocation() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    Position position = await geolocator.getCurrentPosition();
    setState(() => _currentPosition = position);
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
