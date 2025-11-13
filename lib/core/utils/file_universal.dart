import 'package:flutter/material.dart';
/// Universal File - works on mobile (dart:io) and web (package:file)
export 'dart:io' show File if (dart.library.html) 'file_compat_web.dart';
