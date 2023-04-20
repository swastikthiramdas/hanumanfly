import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final height;
  final width;

  MyBarrier({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // print(""+((2 * barrierX + barrierWidth)/(2 - barrierWidth)).toString());
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.circular(15)),
    );
  }
}
/*  final barrierWidth;
  final barrierHeight;
  final barrierX;
  final bool isThisBottomBarrier;*/
/*Container(
      alignment: Alignment((2 * barrierX + barrierWidth)/(2 - barrierWidth),
      isThisBottomBarrier ? 1 : -1),
      child: Container(
        width: size.width * barrierWidth / 2,
        height: size.height * 3 / 4 * barrierHeight / 2,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 10 , color: Colors.lightGreen),
          borderRadius: BorderRadius.circular(15)
        ),
      ),
    );*/
