import 'dart:math';
import 'dart:ui';

import 'package:art_point/classes/colors.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double iter = 9;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      for (int i = 0; i < 2000000; i++) {
        setState(() {
          iter = iter + 0.00001;
        });
        await Future.delayed(const Duration(milliseconds: 50));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter paint art',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CustomPaint(
          painter: CirclePainter(iter),
          child: Container(),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  double iter;
  CirclePainter(this.iter);
  @override
  paint(Canvas canvas, Size size) {
    // Main method
    renderDrawing(canvas, size);
  }

  renderDrawing(Canvas canvas, Size size) {
    // Change background color
    canvas.drawPaint(Paint()..color = Colors.black);

    // Number of iterations to draw
    // 9 shows a lot of hidden details but feel free to tinker around

    renderStructure(canvas, size, iter, iter);
  }

  // Recursive function which draws iterations from iter to 0
  renderStructure(Canvas canvas, Size size, double iter, double initIter) {
    if (iter == 0) {
      return;
    }

    // This was originally meant to capture distance, now while it does have
    // some correlation with distance, don't take that for granted
    // I simply couldn't think of another variable name, my apologies
    double distance = 0.0;

    // Choose a random color for this iteration
    Color randomColor = colors[Random().nextInt(colors.length)].color;

    // Drawing lot of points
    for (double i = 0; i < 20; i += 0.01) {
      canvas.drawCircle(
        // Main section of create recursive circle
        Offset(
          (size.width / 2) +
              // Change these functions for various things to happen
              // Change "atan(distance) * sin(distance) * cos(distance)" to
              // "cos(distance) * sin(distance)" or any combination of
              // trigonometric functions
              (distance * sin(distance)),
          (size.height / 2) +
              // Same changes for these as the top
              // Note that if the top functions and these are the same, you'll
              // get a 45 degree line of points
              (distance * cos(distance)),
        ),
        // Change this for changing radius in different iterations
        5.0 - (0.5 * (initIter - iter)),
        // Well... color
        Paint()..color = randomColor,
      );

      // Change the "0.1" for varying point distances
      distance = distance + (0.2 + (0.1 * initIter - iter));
    }

    // Recursively call the next iteration
    renderStructure(canvas, size, iter - 1, initIter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
