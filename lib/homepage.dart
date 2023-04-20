import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flappybird/barriers.dart';
import 'package:flappybird/my_hanuman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static double BirdY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = BirdY;
  bool gameHasStarted = false;
  int? MyBest;

  // static double BarrierXone = 0;
  // static double BarrierXtwo = BarrierXone + 1.5;
  double birdHeight = 0.1;
  double birdWidth = 0.1;
  int score = 0;
  int best = 0;
  bool Birdded = false;
  static List<double> barrierX = [2, 2 + 1.5]

  /*[0 , 0.1]*/;

  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        if (MyBest! > best) {
          addBest();
        }
        break;
    }
  }

  void addBest() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("best", best);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getBest();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
  }

  void _getBest() async {
    final prefs = await SharedPreferences.getInstance();

    MyBest = prefs.getInt("best");
    setState(() {
      if (MyBest != null) {
        best = MyBest!;
      }
    });
  }

  void Jump() {
    setState(() {
      time = 0;
      initialHeight = BirdY;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(
      Duration(milliseconds: 10),
          (timer) {
        height = -4.9 * time * time + 2 /*3.5*/ * time;
        setState(() {
          BirdY = initialHeight - height;
        });

        if (birdDead()) {
          timer.cancel();
          _showDialog();
        }
        moveMap();

        time += 0.01;
      },
    );
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        score++;
      }
    }
  }

  bool birdDead() {
    if (BirdY > 1 || BirdY < -1) {
      Birdded = true;
      return true;
    }
    /*[0.6, 0.4],
    [0.4, 0.6]*/
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (BirdY <=
              -barrierHeight[i]
              [0] || /* 1.1 = -0.5 , -0.7*/ /* 1 = 0.4 , -0.6*/
              BirdY + birdHeight >= barrierHeight[i][1])) {
        /* 1.1 = 0.7 , 0.5*/ /* 1 = 0.6 , 0.4*/
        Birdded = true;
        return true;
      }
    }
    /*   if (barrierX[0] <= birdHeight &&
        barrierX[0] + barrierWidth >= -birdHeight &&
        (BirdY <= -1 + barrierHeight[00][0] ||
            BirdY + birdHeight >= 1 - barrierHeight[00][1])) {
      return true;
    }*/
    return false;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      BirdY = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = BirdY;
      barrierX[0] = 2;
      Birdded = false;
      barrierX[1] = barrierX[0] + 1.5;
      if (score > best) {
        best = score;
      }
      score = 0;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: const Text(
              'G A M E  O V E R',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            'Score' + score.toString(),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          Jump();
          if ((BirdY < 0 || BirdY > 0) && Birdded == true) {
            _showDialog();
          }
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment(
                            0, (2 * BirdY + birdHeight) / (2 - birdHeight)),
                        child: const MyHanuman(),
                      ),
                      Container(
                        alignment: Alignment(0, -0.5),
                        child: gameHasStarted
                            ? const Text(' ')
                            : const Text(
                          'T A P  TO  S T A R T',
                          style: TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                      //First Cont
                      Container(
                        alignment: Alignment(
                            (2 * barrierX[0] + barrierWidth) /
                                (2 - barrierWidth),
                            1),
                        child: MyBarrier(
                          width: size.width * barrierWidth / 2,
                          height: size.height * 3 / 4 * barrierHeight[0][0] / 2,
                        ),
                      ),
                      //Second Cont
                      Container(
                        alignment: Alignment(
                            (2 * barrierX[0] + barrierWidth) /
                                (2 - barrierWidth),
                            -1),
                        child: MyBarrier(
                          width: size.width * barrierWidth / 2,
                          height: size.height * 3 / 4 * barrierHeight[0][1] / 2,
                        ),
                      ),
                      //Third Cont
                      Container(
                        alignment: Alignment(
                            (2 * barrierX[1] + barrierWidth) /
                                (2 - barrierWidth),
                            1),
                        child: MyBarrier(
                          width: size.width * barrierWidth / 2,
                          height: size.height * 3 / 4 * barrierHeight[1][0] / 2,
                        ),
                      ),
                      //Fourth Cont
                      Container(
                        alignment: Alignment(
                            (2 * barrierX[1] + barrierWidth) /
                                (2 - barrierWidth),
                            -1),
                        child: MyBarrier(
                          width: size.width * barrierWidth / 2,
                          height: size.height * 3 / 4 * barrierHeight[1][1] / 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('SCORE',
                            style:
                            TextStyle(fontSize: 20, color: Colors.white)),
                        const SizedBox(height: 20),
                        Text('' + score.toString(),
                            style: TextStyle(fontSize: 30, color: Colors.white))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'BEST',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text('' + best.toString(),
                            style: TextStyle(fontSize: 30, color: Colors.white))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
