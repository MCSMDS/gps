import 'package:flutter/material.dart';
import 'pages/current_location_widget.dart';
import 'pages/location_stream_widget.dart';

void main() => runApp(MaterialApp(home: GeolocatorExampleApp()));

class GeolocatorExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('地理定位器示例应用程序'),
      ),
      body: Column(children: <Widget>[
        RaisedButton(
          child: Text("持续性"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationStreamWidget(),
              ),
            );
          },
        ),
        RaisedButton(
          child: Text("单次"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CurrentLocationWidget(),
              ),
            );
          },
        ),
      ]),
    );
  }
}
