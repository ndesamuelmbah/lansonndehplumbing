import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static Widget loadingWidget(String message, {String subText = ''}) {
    return Container(
        color: Colors.blue[50],
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(subText)
            ],
          ),
        ));
  }

  static OutlineInputBorder buildBoarder({Color color = Colors.blue}) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(5)));
  }

  static InputDecoration inputDecoration(String labelText,
      {Color? focusedBorderColor,
      Color? enabledBorderColor,
      String prefix = ''}) {
    return InputDecoration(
        focusedBorder: buildBoarder(color: focusedBorderColor ?? Colors.blue),
        errorBorder: buildBoarder(color: Colors.red),
        enabledBorder: buildBoarder(color: enabledBorderColor ?? Colors.green),
        disabledBorder: buildBoarder(color: Colors.blueGrey),
        border: const OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: const TextStyle(
            fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold),
        labelText: labelText,
        alignLabelWithHint: true,
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        hintStyle: const TextStyle(fontSize: 16),
        labelStyle: const TextStyle(fontSize: 16),
        errorStyle: const TextStyle(fontSize: 11));
  }

  static BoxDecoration containerBoxDecoration(
      {Color color = Colors.white,
      Color borderColor = Colors.white,
      double radius = 10,
      double borderWidth = 1}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }

  static ButtonStyle roundedButtonStyle(
      {Color? primaryColor, Size? minSize, double radius = 15}) {
    return ElevatedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        backgroundColor: primaryColor ?? Colors.blue,
        minimumSize: minSize);
  }

  static Widget buildSeparator(double screenWidth, {bool isSmaller = false}) {
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
      width: isSmaller ? screenWidth * 0.6 : screenWidth * 0.8,
      height: 2.0,
      color: Colors.black54,
      margin: const EdgeInsets.only(top: 4.0),
    ));
  }

  static void showToast(String text, Color bgColor) {
    Fluttertoast.showToast(
        msg: text, backgroundColor: bgColor, toastLength: Toast.LENGTH_LONG);
  }

  static void setDialog(BuildContext context,
      {required String title,
      required List<Widget> children,
      required List<Widget> actions,
      bool barrierDismissible = true,
      TextStyle titleStyle = const TextStyle(),
      EdgeInsets padding =
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0)}) {
    AlertDialog dailog = AlertDialog(
        insetPadding: padding,
        backgroundColor: const Color(0xFFE9EDF0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(13))),
        title: Text(title, textAlign: TextAlign.center, style: titleStyle),
        content: SingleChildScrollView(
          child: ListBody(children: children),
        ),
        actions: actions);
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => dailog);
  }
}
