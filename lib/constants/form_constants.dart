import 'package:flutter/material.dart';

ButtonStyle buttonStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        16.0,
      ),
    ),
  ),
  backgroundColor: MaterialStateProperty.all(
    Colors.green,
  ),
);
const InputBorder inputBorderForm = UnderlineInputBorder(
  borderSide: BorderSide(
    color: Colors.green,
    width: 2.0,
  ),
);

const TextStyle textStyleFrom = TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);
