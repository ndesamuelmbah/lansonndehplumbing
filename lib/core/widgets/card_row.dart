import 'package:flutter/material.dart';

import '../utils/color_palette.dart';
import '../utils/text_styles.dart';

class CardRow extends StatelessWidget {
  final String leadingText;
  final String postText;
  const CardRow({Key? key, required this.leadingText, required this.postText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            leadingText,
            style: hintStyle.copyWith(fontSize: 12),
          ),
        ),
        Flexible(
          child: Text(
            postText,
            softWrap: true,
            style: hintStyle.copyWith(
                color: Palette.primary,
                fontSize: 12,
                fontFamily: 'Roboto',
                letterSpacing: 0.1),
          ),
        ),
      ]),
    );
  }
}
