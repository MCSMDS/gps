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

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.best);
      final Stream<Position> positionStream =
          Geolocator().getPositionStream(locationOptions);
      _positionStreamSubscription = positionStream.listen(
          (Position position) => setState(() => _positions.add(position)));
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }

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
    final List<Widget> listItems = <Widget>[
      ListTile(
        title: RaisedButton(
          child: _buildButtonText(),
          color: _determineButtonColor(),
          padding: const EdgeInsets.all(8.0),
          onPressed: _toggleListening,
        ),
      ),
    ];

    listItems.addAll(_positions
        .map((Position position) => PositionListItem(position))
        .toList());

    return ListView(
      children: listItems,
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  Widget _buildButtonText() {
    return Text(_isListening() ? '别听了' : '开始倾听');
  }

  Color _determineButtonColor() {
    return _isListening() ? Colors.red : Colors.green;
  }
}

class PositionListItem extends StatefulWidget {
  const PositionListItem(this._position);

  final Position _position;

  @override
  State<PositionListItem> createState() => PositionListItemState(_position);
}

class PositionListItemState extends State<PositionListItem> {
  PositionListItemState(this._position);
  final Position _position;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Lat: ${_position.latitude}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  'Lon: ${_position.longitude}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ]),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _position.timestamp.toLocal().toString(),
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
