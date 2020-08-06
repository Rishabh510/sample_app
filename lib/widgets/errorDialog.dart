import 'package:flutter/material.dart';

_showDialogError(BuildContext context, dynamic error) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      useSafeArea: true,
      builder: (context) {
        return SimpleDialog(
          elevation: 8,
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.black, width: 2),
          ),
          title: Text('ERROR'),
          children: [
            SimpleDialogOption(
              child: Text(error.toString()),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      });
}
