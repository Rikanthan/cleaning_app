import 'dart:math';
import 'package:flutter/material.dart';

class RandomCircle extends StatelessWidget {
  RandomCircle({Key? key}) : super(key: key);
  final int number = 20 + Random().nextInt(40);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Positioned(
        top: height / 5 + height * Random().nextDouble(),
        left: height * Random().nextDouble(),
        child: Container(
          height: number.toDouble(),
          width: number.toDouble(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(number.toDouble()),
              ),
              color: number % 2 == 0
                  ? Colors.black
                  : Color.fromARGB(255, 3, 26, 44)),
        ));
  }
}
