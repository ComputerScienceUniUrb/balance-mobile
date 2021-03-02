import 'dart:async';

import 'package:balance_app/bloc/main/home/countdown_bloc.dart';
import 'package:balance_app/bloc/main/home/events/countdown_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors/sensors.dart';


class TargetingGame extends StatefulWidget {
  final TargetingGame state;

  TargetingGame({
    Key key,
    this.state,
  }): super(key: key);

  @override
  _TargetingGameState createState() => _TargetingGameState();
}

class _TargetingGameState extends State<TargetingGame> {
  // color of the circle
  Image color = Image.asset("assets/app_logo_circle.png");

  // event returned from accelerometer stream
  AccelerometerEvent event;

  // hold a refernce to these, so that they can be disposed
  Timer timer;
  Timer timer2;
  Timer timer3;
  StreamSubscription accel;

  // positions and count
  double top = 125;
  double left;
  int count = 0;

  // variables for screen size
  double width;
  double height;

  setColor(AccelerometerEvent event) {
    // Calculate Left
    double x = ((event.x * 12) + ((width - 100) / 2));
    // Calculate Top
    double z = event.z * 12 + 125;

    // find the difference from the target position
    var xDiff = x.abs() - ((width - 100) / 2);
    var zDiff = z.abs() - 125;

    // check if the circle is centered, currently allowing a buffer of 3 to make centering easier
    if (xDiff.abs() < 10 && zDiff.abs() < 10) {
      // set the color and increment count
      setState(() {
        color = Image.asset("assets/app_logo_circle.png");
        count += 1;
      });
    } else {
      // set the color and restart count
      setState(() {
        color = Image.asset("assets/app_logo_circle_grey.png");
        count = 0;
      });
    }
  }

  setPosition(AccelerometerEvent event) {
    if (event == null) {
      return;
    }

    // When x = 0 it should be centered horizontally
    // The left position should equal (width - 100) / 2
    // The greatest absolute value of x is 10, multipling it by 12 allows the left position to move a total of 120 in either direction.
    setState(() {
      left = ((event.x * -12) + ((width - 100) / 2));
    });

    // When y = 0 it should have a top position matching the target, which we set at 125
    setState(() {
      top = event.z * 12 + 125;
    });
  }

  startTimer() {
    // if the accelerometer subscription hasn't been created, go ahead and create it
    if (accel == null) {
      accel = accelerometerEvents().listen((AccelerometerEvent eve) {
        setState(() {
          event = eve;
        });
      });
    } else {
      // it has already ben created so just resume it
      accel.resume();
    }

    // Accelerometer events come faster than we need them so a timer is used to only proccess them every 200 milliseconds
    if (timer == null || !timer.isActive) {

      timer2 = Timer.periodic(Duration(milliseconds: 1000), (_) {
        if (count == 0) {
          FlutterBeep.beep();
        }
      });

      timer3 = Timer.periodic(Duration(milliseconds: 500), (_) {
        if (count < 30 && count > 1) {
          FlutterBeep.beep();
        }
      });

      timer = Timer.periodic(Duration(milliseconds: 100), (_) {
        // if count has increased greater than 3 call pause timer to handle success
        if (count > 30) {
          pauseTimer();
          context.bloc<CountdownBloc>().add(CountdownEvents.startPreMeasure);
        } else {
          // proccess the current event
          setColor(event);
          setPosition(event);
        }
      });
    }
  }

  pauseTimer() {
    // stop the timer and pause the accelerometer stream
    timer.cancel();
    timer2.cancel();
    timer3.cancel();
    accel.pause();
    //FlutterBeep.beep();

    // set the success color and reset the count
    setState(() {
      count = 0;
      color = Image.asset("assets/app_logo_circle.png");
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    timer3?.cancel();
    accel?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the width and height of the screen
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Stack(
            children: [
              // This empty container is given a width and height to set the size of the stack
              Container(
                height: height / 2,
                width: width,
              ),

              // Create the outer target circle wrapped in a Position
              Positioned(
                // positioned 50 from the top of the stack
                // and centered horizontally, left = (ScreenWidth - Container width) / 2
                top: 50,
                left: (width - 250) / 2,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigoAccent, width: 3.0),
                    borderRadius: BorderRadius.circular(125),
                  ),
                ),
              ),
              // This is the colored circle that will be moved by the accelerometer
              // the top and left are variables that will be set
              Positioned(
                top: top,
                left: left ?? (width - 100) / 2,
                // the container has a color and is wrappeed in a ClipOval to make it round
                child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: color,
                      ),
                    )
                ),
              ),
              // inner target circle wrapped in a Position
              Positioned(
                top: 125,
                left: (width - 100) / 2,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan, width: 3.0),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          );
  }
}