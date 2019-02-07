import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class _JumpingDot extends AnimatedWidget {
  final Color color;
  final double fontSize;
  _JumpingDot({
    Key key,
    Animation<double> animation,
    this.color,
    this.fontSize
  }) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      height: animation.value,
      child: Text('.', style: TextStyle(color: color, fontSize: fontSize),),
    );
  }
}

class DotProgress extends StatefulWidget {
  @override
  _DotProgressState createState() => _DotProgressState();
}

class _DotProgressState extends State<DotProgress> with TickerProviderStateMixin{

  List<AnimationController> controllers = List<AnimationController>();
  List<Animation<double>> animations = List<Animation<double>>();
  List<Widget> _widgets = List<Widget>();

  void _addAnimationControllers() {
    controllers.add(AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this
    ));
  }

  void _addListOfDots(int index) {
    _widgets.add(Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: _JumpingDot(
        animation: animations[index],
        fontSize: 100.0,
        color: Colors.white,
      ),
    ));
  }

  void _buildAnimations(int index) {
    animations.add(
      Tween(begin: 0.0, end: 8.0).animate(controllers[index])
      ..addStatusListener((AnimationStatus status) {
        if(status == AnimationStatus.completed) {
          controllers[index].reverse();
        }
        if(index == 2 && status == AnimationStatus.dismissed) {
          controllers[0].forward();
        }
        if(animations[index].value > 8.0 / 2 && index < 2) {
          controllers[index + 1].forward();
        }
      })
    );
  }

  @override
    void initState() {
      super.initState();
      for (int i = 0; i < 3; i++) {
        _addAnimationControllers();
        _buildAnimations(i);
        _addListOfDots(i);
      }

      controllers[0].forward();
    }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _widgets,
      ),
    );
  }

  @override
    void dispose() {
      for ( int i = 0; i < 3; i++) {
        controllers[i].dispose();
      }
      super.dispose();
    }
}