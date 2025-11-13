import 'package:flutter/material.dart';
class NoInternetException {
  final Object? message;

  NoInternetException(this.message);
}

class NoServiceFoundException {
  final Object? message;

  NoServiceFoundException(this.message);
}

class InvalidFormatException {
  final Object? message;

  InvalidFormatException(this.message);
}

class UnknownException {
  final Object? message;

  UnknownException(this.message);
}
