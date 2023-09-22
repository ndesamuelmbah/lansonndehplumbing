import 'dart:io';

import 'package:lansonndehplumbing/core/utils/strings.dart';

class Failure {
  final String message;
  final int code;
  final Exception? originalException;

  Failure({required this.message, this.code = 0, this.originalException});

  factory Failure.fromString(String? message) {
    return Failure(
      message: Strings.somethingWrong,
      code: 0,
    );
  }

  factory Failure.fromException(e, [trace]) {
    if (e is SocketException) {
      return InternetFailure();
    }
    if (e is Failure) {
      return e;
    }
    if (e != null && e is String) {
      return Failure(
        message: Strings.somethingWrong,
        code: 0,
      );
    }

    return Failure(
      message: Strings.somethingWrong,
      code: 0,
      originalException: e,
    );
  }

  @override
  String toString() {
    return Strings.somethingWrong;
  }
}

class InternetFailure extends Failure {
  InternetFailure() : super(message: Strings.somethingWrong, code: 100);
}
