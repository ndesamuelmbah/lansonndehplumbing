import 'package:lansonndehplumbing/core/utils/strings.dart';
import 'package:lansonndehplumbing/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  final String message;
  final Function()? onRefresh;

  const CustomError({Key? key, this.message = '', this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message.isNotEmpty ? message : Strings.somethingWrong,
          style: hintStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (onRefresh != null)
          Center(
            child: OutlinedButton(
              onPressed: onRefresh,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(Icons.refresh),
                    Text(Strings.reload),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
