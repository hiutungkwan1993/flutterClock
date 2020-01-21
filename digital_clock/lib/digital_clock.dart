// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:digital_clock/rotate_animated_container.dart';
import 'package:digital_clock/scale_animated_container.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  colors,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.white,
  _Element.colors: [
    Colors.red,
    Colors.orange,
  ],
};

final _darkTheme = {
  _Element.background: Color(0xff303030),
  _Element.text: Color(0xff303030),
  _Element.colors: [
    Color(0xfffdfd00),
    Color(0xfff0f000),
  ],
};

final _weatherIcons = {
  'cloudy': FontAwesomeIcons.cloud,
  'foggy': FontAwesomeIcons.smog,
  'rainy': FontAwesomeIcons.cloudRain,
  'snowy': FontAwesomeIcons.snowflake,
  'sunny': FontAwesomeIcons.sun,
  'thunderstorm': FontAwesomeIcons.pooStorm,
  'windy': FontAwesomeIcons.wind,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  String _temperatureString = '--';
  String _weatherString = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      _temperatureString = widget.model.temperatureString;
      _weatherString = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final weekday = DateFormat('EEE').format(_dateTime);

    return Container(
      color: colors[_Element.background],
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                ScaleAnimatedContainer(
                  child: RotateAnimatedContainer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: colors[_Element.colors],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth / 16,
                  bottom: constraints.maxHeight / 16,
                  child: Icon(
                    _weatherIcons[_weatherString],
                    color: colors[_Element.text],
                    size: constraints.maxWidth / 3.0,
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth / 24,
                  top: constraints.maxHeight / 8,
                  child: Text(
                    '$hour:$minute',
                    style: TextStyle(
                      color: colors[_Element.text],
                      fontSize: constraints.maxWidth / 4.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth / 24,
                  top: constraints.maxHeight / 2.6,
                  child: Text(
                    _temperatureString,
                    style: TextStyle(
                      color: colors[_Element.text],
                      fontSize: constraints.maxWidth / 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth / 24,
                  top: constraints.maxHeight / 1.9,
                  child: Text(
                    weekday,
                    style: TextStyle(
                      color: colors[_Element.text],
                      fontSize: constraints.maxWidth / 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
