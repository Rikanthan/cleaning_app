import 'dart:math';
import 'package:flutter/material.dart';

class RandomCircle extends StatelessWidget {
  RandomCircle({Key? key}) : super(key: key);
  final int number = 20 + Random().nextInt(40);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Positioned(
        top: height / 3 + height * Random().nextDouble(),
        left: height * Random().nextDouble(),
        child: Container(
            height: number.toDouble(),
            width: number.toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(number.toDouble()),
              ),
              color: number % 2 == 0
                  ? Color.fromARGB(255, 54, 54, 54).withOpacity(0.1)
                  : Color.fromARGB(255, 167, 207, 238).withOpacity(0.1),
            )));
  }
}
