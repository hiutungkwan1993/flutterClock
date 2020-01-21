import 'dart:math' as math;

import 'package:flutter/material.dart';

class RotateAnimatedContainer extends StatefulWidget {
  final Widget child;

  const RotateAnimatedContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _RotateAnimatedContainerState createState() =>
      _RotateAnimatedContainerState();
}

class _RotateAnimatedContainerState extends State<RotateAnimatedContainer>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _animation.value,
      child: widget.child,
    );
  }
}
