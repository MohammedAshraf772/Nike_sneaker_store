import 'package:flutter/material.dart';

class AnimatedStepWrapper extends StatelessWidget {
  final Widget child;
  final Animation<double> fadeAnim;
  final Animation<Offset>? slideAnim;

  const AnimatedStepWrapper({
    super.key,
    required this.child,
    required this.fadeAnim,
    this.slideAnim,
  });

  @override
  Widget build(BuildContext context) {
    Widget current = FadeTransition(opacity: fadeAnim, child: child);
    if (slideAnim != null) {
      current = SlideTransition(position: slideAnim!, child: current);
    }
    return current;
  }
}
