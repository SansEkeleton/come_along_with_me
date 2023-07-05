


import 'package:flutter/material.dart';

class logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 50),
              child: Image.asset("assets/Logo_CAWM.png"),
    )]);
  }
}