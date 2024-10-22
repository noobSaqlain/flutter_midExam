import "package:flutter/material.dart";
import 'package:mid/widgets/myHomePage.dart';

void main() {
  return runApp(MaterialApp(
    title: 'MIDS',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: Colors.blue, secondary: Colors.blueGrey)),
    home: const Myhomepage(),
  ));
}
