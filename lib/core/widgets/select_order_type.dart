import 'package:flutter/material.dart';
import 'package:lansonndehplumbing/core/widgets/action_button.dart';

class SelectOrderType extends StatelessWidget {
  final void Function() onSmallOrderPressed;
  final void Function() onCateringOrderPressed;
  const SelectOrderType(
      {Key? key,
      required this.onSmallOrderPressed,
      required this.onCateringOrderPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionButton(
          text: 'Buy Fittings',
          color: Colors.lightGreenAccent,
          maxWidth: 150,
          fontWeight: FontWeight.bold,
          radius: 5,
          backgroundColor: Colors.lightGreenAccent.shade100.withOpacity(0.2),
          onPressed: onSmallOrderPressed,
        ),
        ActionButton(
          text: 'Installations',
          color: Colors.lightGreenAccent,
          maxWidth: 150,
          fontWeight: FontWeight.bold,
          radius: 5,
          backgroundColor: Colors.lightGreenAccent.shade100.withOpacity(0.2),
          onPressed: onCateringOrderPressed,
        ),
      ],
    );
  }
}
