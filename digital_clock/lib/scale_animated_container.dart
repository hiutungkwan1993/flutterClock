import 'package:flutter/material.dart';

class ScaleAnimatedContainer extends StatefulWidget {
  final Widget child;

  const ScaleAnimatedContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _ScaleAnimatedContainerState createState() => _ScaleAnimatedContainerState();
}

class _ScaleAnimatedContainerState extends State<ScaleAnimatedContainer>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0.9).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _animation.value,
      child: widget.child,
    );
  }
}
