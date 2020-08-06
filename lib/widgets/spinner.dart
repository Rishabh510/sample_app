import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget spinner(BuildContext context) {
  return Container(
    color: Colors.black.withOpacity(0.4),
    child: Center(
      child: SpinKitChasingDots(
        color: Colors.deepOrange,
        duration: Duration(milliseconds: 1000),
        size: MediaQuery.of(context).size.width / 2,
      ),
    ),
  );
}
