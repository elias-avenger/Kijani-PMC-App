import 'package:flutter/material.dart';

ButtonStyle kGreenButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
  padding:
      WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(16)),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
);
