import 'package:flutter/material.dart';

navPush(BuildContext context, Widget page) {
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => page));
}

navPop(BuildContext context) {
  return Navigator.of(context).pop();
}