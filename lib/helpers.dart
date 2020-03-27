import 'package:flutter/material.dart';

Future<void> showOkDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text(message,
      textAlign: TextAlign.center,
      style: new TextStyle(
        fontSize: 16.0),
      ),
      content: new Container(
        child: new RaisedButton(
          child: new Text("OK",
          textAlign: TextAlign.center),
          onPressed: () { 
            Navigator.of(context).pop();
          },
        ),
      ),
    )
  );
}