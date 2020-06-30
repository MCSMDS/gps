import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'placeholder_widget.dart';

class CurrentLocationWidget2 extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget2> {
  Position _lastKnownPosition;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }

  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });
  }

  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = true
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
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
            return const PlaceholderWidget('Access to location denied',
                'Allow access to the location services for this App using the device settings.');
          }

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Text(
                    'Geolocator is using the raw location manager classes shipped with the operating system.',
                    textAlign: TextAlign.center,
                  ),
                ),
                PlaceholderWidget(
                    'Last known location:', _lastKnownPosition.toString()),
                PlaceholderWidget(
                    'Current location:', _currentPosition.toString()),
              ],
            ),
          );
        },
      ),
    );
  }
}
