import 'package:flutter/material.dart';

Widget myText(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      shadows: [Shadow(color: Colors.black, offset: Offset(-2, 2))],
    ),
  );
}
