import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Size;
import 'package:intl/intl.dart' show NumberFormat;

import 'package:universal_html/html.dart' as html;

final RegExp replaceWhiteSpacePattern = RegExp(r"[,\s+]");
final numberFormat = NumberFormat("#,##0.00", "en_US");
const String dGLetters =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
String fixText(String text, {String replaceWith = ' '}) {
  return text.replaceAll(replaceWhiteSpacePattern, replaceWith);
}

const int maxOrderRadiusInMiles = 10;

String getFormatedCurrency(String currencySymbol, num amount) =>
    '$currencySymbol${numberFormat.format(amount)}';

List<String> getListOfValidStringsFromStirng(String? inputString,
    [String splitPattern = ',']) {
  inputString = inputString?.trim();
  if (inputString == null) {
    return [];
  }
  List<String> validStrings = [];
  for (String subString
      in inputString.split(splitPattern).map((e) => e.trim())) {
    if (subString.length > 2) {
      validStrings.add(subString);
    }
  }
  return validStrings;
}

String getSupportPhone(String countryCode) {
  return '+256764430769';
  // String cc = countryCode.toLowerCase().trim();
  // if ('cm td ml sn tg cf bj bf ga fg gw cg cd ci ne tg'.contains(cc)) {
  //   return "+237676297472";
  // } else if ('tz rw ug ke so sd mw cd za bw zm ss'.contains(cc)) {
  //   return "+250781976155";
  // } else if ('ng' == cc) {
  //   return "+2348121693506";
  // } else {
  //   return '+13016408856';
  // }
}

int getConstrainedWidth(Size size, int max) {
  num use = size.width > max ? max : size.width;
  return use ~/ 350;
}

double getPadding(Size size, {bool forForm = false}) {
  double width = size.width;
  if (forForm) {
    if (width < 400) {
      return 5;
    }
    return (width - 400) / 2;
  }
  if (width < 600) {
    return 0;
  }
  if (width > 1300) {
    return (width - 1300) / 2;
  }
  return width * 0.05;
}

String getChatMessageId(num time) {
  int timeId = (time) as int;
  if (timeId < 62) {
    return dGLetters[timeId];
  }
  String res = '';
  int remainder = 0;
  while (timeId > 61) {
    remainder = timeId % 62;
    timeId ~/= 62;
    res += dGLetters[remainder];
  }
  res += dGLetters[remainder];
  return res;
}

bool kIsWebOnMobile({bool isMobile = false}) {
  if (isMobile) {
    return isMobile;
  }
  if (kIsWeb) {
    String userAgent = html.window.navigator.userAgent;
    userAgent = userAgent.toLowerCase();
    if (userAgent.contains('android') ||
        userAgent.contains('ios') ||
        userAgent.contains('mobile') ||
        userAgent.contains('iphone')) {
      return true;
    }
  }
  return false;
}

String getUserAgent() {
  if (kIsWeb) {
    return html.window.navigator.userAgent;
  }
  return 'No User Agent';
}
