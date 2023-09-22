import 'package:flutter/material.dart';

class BouncingFAB extends StatefulWidget {
  final Function() onPressed;

  const BouncingFAB({super.key, required this.onPressed});

  @override
  BouncingFABState createState() => BouncingFABState();
}

class BouncingFABState extends State<BouncingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
      reverseCurve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 1.0 + _animation.value * 0.2,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            child: const Icon(Icons.person),
          ),
        );
      },
    );
  }
}
