import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  AdaptiveFlatButton(this.text, this.handler);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black54),
              elevation: MaterialStateProperty.all(5),
              shadowColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: handler,
            child: const Text(
              'Choose Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
