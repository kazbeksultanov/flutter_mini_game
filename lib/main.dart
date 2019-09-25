// Copyright (c) 1998, 1999, 2000 Thai Open Source Software Center Ltd
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
//     distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scoreRed = 0;
  var scoreBlue = 0;
  double xPosTap = 0;
  double yPosTap = 0;
  double xPosRed = 180.0;
  double yPosRed = 660.0;
  double stepDistance = 80.0;
  double playerFractionOnStep = 0.2;
  double shotFractionOnStep = 1.5;
  bool isShotRed = false;
  double xPosShotRed = 180.0;
  double yPosShotRed = 500.0;
  double xPosBlue = 180.0;
  double yPosBlue = 180.0;
  bool isShotBlue = false;
  double xPosShotBlue = 180.0;
  double yPosShotBlue = 120.0;
  bool isRedDead = false;
  bool isBlueDead = false;

  var shotDis = 350;

  void restartKeepingScore() {
    xPosRed = 180.0;
    yPosRed = 660.0;
    xPosShotRed = 180.0;
    yPosShotRed = 660.0;
    xPosBlue = 180.0;
    yPosBlue = 180.0;
    xPosShotBlue = 180.0;
    yPosShotBlue = 180.0;
    isRedDead = false;
    isBlueDead = false;
  }

//  void updateOnShot() {
//    xPosShotRed = xPosRed;
//    yPosShotRed = yPosRed;
//    xPosShotBlue = xPosBlue;
//    yPosShotBlue = yPosBlue;
//  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(
              "assets/astro.jpg",
              width: width,
              height: height,
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
          CustomPaint(
            painter: GamePainter(
              xPosTap,
              yPosTap,
              xPosRed,
              yPosRed,
              stepDistance,
              playerFractionOnStep,
              shotFractionOnStep,
              isShotRed,
              xPosShotRed,
              yPosShotRed,
              xPosBlue,
              yPosBlue,
              xPosShotBlue,
              yPosShotBlue,
              isShotBlue,
              isRedDead,
              isBlueDead,
            ),
            child: GestureDetector(
              onTapDown: updateOnTapDown,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  scoreBlue.toString(),
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 36.0,
                  ),
                ),
                Text(
                  '------',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  scoreRed.toString(),
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 36.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateOnTapDown(TapDownDetails details) {
    xPosTap = details.globalPosition.dx;
    yPosTap = details.globalPosition.dy;
    print(xPosTap.toString() + ", " + yPosTap.toString());
    double wishedStepRed = sqrt(pow(xPosTap - xPosRed, 2) + pow(yPosTap - yPosRed, 2));
    if (stepDistance >= wishedStepRed) {
      xPosRed = xPosTap;
      yPosRed = yPosTap;
      isShotRed = false;
      setState(() {});
    } else if (stepDistance <= wishedStepRed && wishedStepRed <= stepDistance * shotFractionOnStep) {
      isShotRed = true;
      double cosa = (xPosTap - xPosRed) / wishedStepRed;
      double sina = (yPosTap - yPosRed) / wishedStepRed;
      xPosShotRed = shotDis * cosa + xPosRed;
      yPosShotRed = shotDis * sina + yPosRed;
      setState(() {});
    } else {
      isShotRed = false;
    }

    double wishedStepBLue = sqrt(pow(xPosTap - xPosBlue, 2) + pow(yPosTap - yPosBlue, 2));
    if (stepDistance >= wishedStepBLue) {
      xPosBlue = xPosTap;
      yPosBlue = yPosTap;
      isShotBlue = false;
    } else if (stepDistance <= wishedStepBLue && wishedStepBLue <= stepDistance * shotFractionOnStep) {
      isShotBlue = true;
      double cosa = (xPosTap - xPosBlue) / wishedStepBLue;
      double sina = (yPosTap - yPosBlue) / wishedStepBLue;
      xPosShotBlue = shotDis * cosa + xPosBlue;
      yPosShotBlue = shotDis * sina + yPosBlue;
      setState(() {});
    } else {
      isShotBlue = false;
    }

    double x1 = xPosRed;
    double y1 = yPosRed;
    double x2 = xPosShotRed;
    double y2 = yPosShotRed;
    double x0 = xPosBlue;
    double y0 = yPosBlue;
    double d = stepDistance * playerFractionOnStep / 2;
    if (((x1 - d <= x0 && x0 <= x2 + d) || (x2 - d <= x0 && x0 <= x1 + d)) && ((y1 - d <= y0 && y0 <= y2 + d) || (y2 - d <= y0 && y0 <= y1 + d))) {
//    if (shotDis >= sqrt(pow(x1 - x0, 2) + pow(y1 - y2, 2))) {
      if (stepDistance * playerFractionOnStep >= (((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1).abs()) / sqrt((pow(y2 - y1, 2) + pow(x2 - x1, 2)))) {
        print("Red won long");
        ++scoreRed;
        isBlueDead = true;
        setState(() {});
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Red is Won!",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text("Want to restart keeping the score? Or restart everything?"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Keep")),
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        scoreBlue = 0;
                        scoreRed = 0;
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Restart")),
                ],
              );
            }).whenComplete(() {
          restartKeepingScore();
        });
      } else {
        setState(() {});
      }
    } else {
      if (stepDistance * playerFractionOnStep >= sqrt((pow(y2 - y0, 2) + pow(x2 - x0, 2)))) {
        print("Red won end point");
        ++scoreRed;
        isBlueDead = true;
        setState(() {});
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Red is Won!",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text("Want to restart keeping the score? Or restart everything?"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Keep")),
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        scoreBlue = 0;
                        scoreRed = 0;
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Restart")),
                ],
              );
            }).whenComplete(() {
          restartKeepingScore();
        });
      } else {
        setState(() {});
      }
    }

    x1 = xPosBlue;
    y1 = yPosBlue;
    x2 = xPosShotBlue;
    y2 = yPosShotBlue;
    x0 = xPosRed;
    y0 = yPosRed;

    if (((x1 - d <= x0 && x0 <= x2 + d) || (x2 - d <= x0 && x0 <= x1 + d)) && ((y1 - d <= y0 && y0 <= y2 + d) || (y2 - d <= y0 && y0 <= y1 + d))) {
      if (stepDistance * playerFractionOnStep >= (((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1).abs()) / sqrt((pow(y2 - y1, 2) + pow(x2 - x1, 2)))) {
        print("Blue won long");
        isRedDead = true;
        ++scoreBlue;
        setState(() {});
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Blue is Won!",
                  style: TextStyle(color: Colors.blue),
                ),
                content: Text("Want to restart keeping the score? Or restart everything?"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Keep")),
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        scoreBlue = 0;
                        scoreRed = 0;
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Restart")),
                ],
              );
            }).whenComplete(() {
          restartKeepingScore();
        });
      } else {
        setState(() {});
      }
    } else {
      if (stepDistance * playerFractionOnStep >= sqrt((pow(y2 - y0, 2) + pow(x2 - x0, 2)))) {
        print("Blue won end point");
        ++scoreBlue;
        isRedDead = true;
        setState(() {});
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Blue is Won!",
                  style: TextStyle(color: Colors.blue),
                ),
                content: Text("Want to restart keeping the score? Or restart everything?"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Keep")),
                  FlatButton(
                      onPressed: () {
                        restartKeepingScore();
                        scoreBlue = 0;
                        scoreRed = 0;
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Restart")),
                ],
              );
            }).whenComplete(() {
          restartKeepingScore();
        });
      } else {
        setState(() {});
      }
    }
  }
}

class GamePainter extends CustomPainter {
  final double xPosTap;
  final double yPosTap;
  final double xPosRed;
  final double yPosRed;
  final double stepDistance;
  final double playerFractionOnStep;
  final double shotFractionOnStep;
  final bool isShotRed;
  final double xPosShotRed;
  final double yPosShotRed;
  final double xPosBlue;
  final double yPosBlue;
  final double xPosShotBlue;
  final double yPosShotBlue;
  final bool isShotBlue;
  final bool isRedDead;
  final bool isBlueDead;

  const GamePainter(
    this.xPosTap,
    this.yPosTap,
    this.xPosRed,
    this.yPosRed,
    this.stepDistance,
    this.playerFractionOnStep,
    this.shotFractionOnStep,
    this.isShotRed,
    this.xPosShotRed,
    this.yPosShotRed,
    this.xPosBlue,
    this.yPosBlue,
    this.xPosShotBlue,
    this.yPosShotBlue,
    this.isShotBlue,
    this.isRedDead,
    this.isBlueDead,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paintPlayer = Paint();
    paintPlayer.color = Colors.red[500];
    paintPlayer.style = PaintingStyle.fill;
    paintPlayer.strokeWidth = 1.0;

    canvas.drawCircle(Offset(xPosRed, yPosRed), stepDistance * playerFractionOnStep, paintPlayer);

    var paintStepCircle = Paint();
    paintStepCircle.color = Colors.redAccent;
    paintStepCircle.style = PaintingStyle.stroke;
    paintStepCircle.strokeWidth = 1.0;
    paintStepCircle.color = Colors.red;

    canvas.drawCircle(Offset(xPosRed, yPosRed), stepDistance, paintStepCircle);

    var paintGunCircle = Paint();
    paintGunCircle.color = Colors.redAccent;
    paintGunCircle.style = PaintingStyle.stroke;
    paintGunCircle.strokeWidth = 1.0;
    paintGunCircle.color = Colors.greenAccent;

    canvas.drawCircle(Offset(xPosRed, yPosRed), stepDistance * shotFractionOnStep, paintGunCircle);

    // Enemy Variable
    var paintEnemy = Paint();
    paintEnemy.color = Colors.blue[500];
    paintEnemy.style = PaintingStyle.fill;
    paintEnemy.strokeWidth = 1.0;
    paintStepCircle.color = Colors.blueAccent;

    canvas.drawCircle(Offset(xPosBlue, yPosBlue), stepDistance * playerFractionOnStep, paintEnemy);
    canvas.drawCircle(Offset(xPosBlue, yPosBlue), stepDistance, paintStepCircle);
    canvas.drawCircle(Offset(xPosBlue, yPosBlue), stepDistance * shotFractionOnStep, paintGunCircle);

    if (isShotRed) {
      var paintGunShotLine = Paint();
      paintGunShotLine.color = Colors.redAccent;
      paintGunShotLine.style = PaintingStyle.stroke;
      paintGunShotLine.strokeWidth = 1.0;

      canvas.drawLine(Offset(xPosRed, yPosRed), Offset(xPosShotRed, yPosShotRed), paintGunShotLine);
    }

    if (isShotBlue) {
      var paintGunShotLine = Paint();
      paintGunShotLine.color = Colors.blueAccent;
      paintGunShotLine.style = PaintingStyle.stroke;
      paintGunShotLine.strokeWidth = 1.0;

      canvas.drawLine(Offset(xPosBlue, yPosBlue), Offset(xPosShotBlue, yPosShotBlue), paintGunShotLine);
    }

    if (isRedDead) {
      var delta = 30;
      var pa = Paint();
      pa.color = Colors.black;
      pa.strokeWidth = 3.0;
      canvas.drawLine(Offset(xPosRed - delta, yPosRed - delta), Offset(xPosRed + delta, yPosRed + delta), pa);
      canvas.drawLine(Offset(xPosRed + delta, yPosRed - delta), Offset(xPosRed - delta, yPosRed + delta), pa);
    }

    if (isBlueDead) {
      var delta = 30;
      var pa = Paint();
      pa.color = Colors.black;
      pa.strokeWidth = 3.0;
      canvas.drawLine(Offset(xPosBlue - delta, yPosBlue - delta), Offset(xPosBlue + delta, yPosBlue + delta), pa);
      canvas.drawLine(Offset(xPosBlue + delta, yPosBlue - delta), Offset(xPosBlue - delta, yPosBlue + delta), pa);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
