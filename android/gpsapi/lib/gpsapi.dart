import 'dart:async';

import 'package:flutter/services.dart';

class Gps {
  static const MethodChannel _channel = const MethodChannel('gpsapi');

  static Future<GpsLatlng> currentGps() async {
    try {
      var map = await _channel.invokeMethod("getLocation");
      if (map == null) {
        return null;
      }
      return GpsLatlng.fromMap(map.cast<dynamic, dynamic>());
    } catch (e) {
      return null;
    }
  }
}

class GpsLatlng {
  double latitude;
  double longitude;
  double altitude;
  DateTime timestamp;

  GpsLatlng._();

  factory GpsLatlng.fromMap(Map<dynamic, dynamic> map) {
    return GpsLatlng._()
      ..latitude = map["latitude"]
      ..longitude = map["longitude"]
      ..altitude = map["altitude"]
      ..timestamp = DateTime.fromMillisecondsSinceEpoch(
          map['timestamp'].toInt(),
          isUtc: true);
  }

  @override
  String toString() {
    return "${this.latitude}, ${this.longitude}, ${this.altitude}, ${timestamp.toLocal()}";
  }
}
