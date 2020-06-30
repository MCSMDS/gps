import 'package:flutter/material.dart';
import 'current_location_widget.dart';
import 'location_stream_widget.dart';
import 'location_widget.dart';

void main() => runApp(MaterialApp(home: GeolocatorExampleApp()));

class GeolocatorExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS'),
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
        RaisedButton(
          child: Text("单次"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CurrentLocationWidget2(),
              ),
            );
          },
        ),
      ]),
    );
  }
}
