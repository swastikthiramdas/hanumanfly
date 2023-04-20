import 'package:flutter/material.dart';

class MyHanuman extends StatelessWidget {
  const MyHanuman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Container(
      // width: 50,
      // height: 50,
      width: size.height * 0.1 / 2,
      height: size.height * 3 / 4 * 0.1 / 2,
      child: Image.asset('assets/flappy_bird.webp')
    );
  }
}
