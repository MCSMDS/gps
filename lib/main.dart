import 'package:flutter/material.dart';
import 'pages/current_location_widget.dart';
import 'pages/location_stream_widget.dart';

void main() => runApp(_GeolocatorExampleApp());

class _GeolocatorExampleApp extends StatefulWidget {
  @override
  State<_GeolocatorExampleApp> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<_GeolocatorExampleApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('地理定位器示例应用程序'),
        ),
        body: new Column(children: <Widget>[
          RaisedButton(
            child: Text("1"),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new LocationStreamWidget(),
                ),
              );
            },
          ),
          RaisedButton(
            child: Text("2"),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new CurrentLocationWidget(),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
