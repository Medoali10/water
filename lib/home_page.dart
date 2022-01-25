import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as Vector;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>  with TickerProviderStateMixin {
  late FlutterLocalNotificationsPlugin localNotification;
  final databaseRef = FirebaseDatabase.instance.reference();
  int waterbutton = 0;
  int servobutton = 0;
  bool once = false;
  late AnimationController animationController;
  int temp = 0;

  updateData(String name,int data) {
    databaseRef.update({name: data});
  }

  @override
  void initState() {
    super.initState();
    // android settings initialiizer
    var androidIntialize =  AndroidInitializationSettings("ic_launcher");

    // IOS settings Initializer

    var iOSIntialize =  IOSInitializationSettings();
    //Initilization Settings

    var initialzationSettings =  InitializationSettings(
        android: androidIntialize , iOS: iOSIntialize
    );

    // setting up local notification
    localNotification =  FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);

    databaseRef.onValue.listen((event) {
      if(event.snapshot.exists){
        setState(() {
          servobutton = event.snapshot.value["servobutton"];
          temp = event.snapshot.value["temp"];
        });
        if(temp >= 45 && once == false){
          _shownotification();
          once = true;
        }
        else if (temp < 45){
          once = false;
        }
      }
    });
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  // Notification function
  Future _shownotification() async {
    var androidDetails =  AndroidNotificationDetails("channelId", "Notifier", importance: Importance.high);

    var iosDetails = IOSNotificationDetails();

    var generalNotificationDetails = NotificationDetails(android : androidDetails , iOS: iosDetails);



    await localNotification.show(0 , "Hot", "Water is 45 degree or more", generalNotificationDetails);


  }


  @override
  Widget build(BuildContext context) {
    var progress = 0.5;
    progress = 1.0 - progress;
    final size = MediaQuery.of(context).size;
        return Scaffold(
          appBar: AppBar(
            leading: Icon(
              Icons.home,
                  color: temp >= 45? Colors.red : Colors.blue,
            ),
            centerTitle: true,
            title: Text("One light One life",
            style: TextStyle(
              color:  temp >= 45? Colors.red : Colors.blue,
              fontSize: 24
            ),),
            backgroundColor: Colors.white,
          ),
                backgroundColor: const Color(0xFFf7f7f7),
                body:Stack(
                  children: <Widget>[
                    AnimatedContainer(
                      color: temp >= 45 ? Colors.red[300] : Colors.blue[300],
                    duration: Duration(seconds: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Stack(
                        children: <Widget>[
                          SafeArea(
                              child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 24.0),
                                        child: Center(),
                                      ),
                                      Expanded(
                                        child: ContainerWrapper(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      Center(child: Image.asset('assets/images/drop.png')),
                                                      Center(
                                                        child: AnimatedBuilder(
                                                            animation: CurvedAnimation(
                                                                parent: animationController, curve: Curves.easeInOut),
                                                            builder: (context, child) => ClipPath(
                                                              child: Image.asset('assets/images/drop-blue.png'),
                                                              clipper: WaveClipper(
                                                                  progress,
                                                                  (progress > 0.0 && progress < 1.0)
                                                                      ? animationController.value
                                                                      : 0.0),
                                                            ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Column(
                                                          children: <Widget>[
                                                            InkWell(
                                                              child: Text(
                                                                '$temp'+ '°',
                                                                style: TextStyle(
                                                                    color: Colors.white.withAlpha(200),
                                                                    fontSize: 30.0,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                InkWell(
                                                  splashColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () {
                                                    if(temp < 45){
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              content: Container(
                                                                height: 100,
                                                                child: Stack(
                                                                  overflow: Overflow.visible,
                                                                  children: <Widget>[
                                                                    Positioned(
                                                                      right: -40.0,
                                                                      top: -40.0,
                                                                      child: InkResponse(
                                                                        onTap: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: CircleAvatar(
                                                                          child: Icon(Icons.close),
                                                                          backgroundColor: Colors.transparent,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      children: const [
                                                                        Text("We will notify you when the water is hot"),
                                                                        SizedBox(
                                                                          height: 25,
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    } else {
                                                      setState(() {
                                                        waterbutton = 1;
                                                      });
                                                      updateData("waterbutton" ,waterbutton);
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              content: Container(
                                                                height: 100,
                                                                child: Stack(
                                                                  overflow: Overflow.visible,
                                                                  children: <Widget>[
                                                                    Positioned(
                                                                      right: -40.0,
                                                                      top: -40.0,
                                                                      child: InkResponse(
                                                                        onTap: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: CircleAvatar(
                                                                          child: Icon(Icons.close),
                                                                          backgroundColor: Colors.transparent,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      children: const [
                                                                        Text("Water is on it's way to you"),
                                                                        SizedBox(
                                                                          height: 25,
                                                                        ),
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    }
                                                  },
                                                  child: AnimatedContainer(
                                                    color: temp >= 45 ? Colors.red[300] : Colors.blue[300],
                                                    duration: Duration(seconds: 1),
                                                    height: 70,
                                                    width: 200,
                                                    child: Center(
                                                      child: Text(
                                                        'Request water',
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                InkWell(
                                                  splashColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: servobutton == 0?  () {
                                                    setState(() {
                                                      servobutton = 1;
                                                    });
                                                    updateData("servobutton" ,servobutton);
                                                  } : () {
                                                    setState(() {
                                                      servobutton = 0;
                                                    });
                                                    updateData("servobutton" ,servobutton);
                                                  },
                                                  child: AnimatedContainer(
                                                    color: temp >= 45 ? Colors.red[300] : Colors.blue[300],
                                                    duration: Duration(seconds: 1),
                                                    height: 70,
                                                    width: 200,
                                                    child: Center(
                                                      child: Text(
                                                        servobutton == 0?"Servo button: Off" : "Servo button: On" ,
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        children: const <Widget>[
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                          children: const <Widget>[
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ))),
                          Positioned(
                              bottom: 0.0,
                              height: 160.0,
                              child: SizedBox(
                                width: size.width,
                                height: 160.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: const [0.3, 0.7],
                                        colors: [Colors.white.withOpacity(0.0), Colors.white]),
                                  ),
                                ),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 48.0),
                                child: Center(child: Center()),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
  }



}

class WaveClipper extends CustomClipper<Path> {
  final double progress;
  final double animation;

  WaveClipper(this.progress, this.animation);

  @override
  Path getClip(Size size) {
    final double wavesHeight = size.height * 0.1;

    var path = new Path();

    if (progress == 1.0) {
      return path;
    } else if (progress == 0.0) {
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.lineTo(0.0, 0.0);
      return path;
    }

    List<Offset> wavePoints = [];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      var extraHeight = wavesHeight * 0.5;
      extraHeight *= i / (size.width / 2 - size.width);
      var dx = i.toDouble();
      var dy = sin((animation * 360 - i) % 360 * Vector.degrees2Radians) * 5 +
          progress * size.height -
          extraHeight;
      if (!dx.isNaN && !dy.isNaN) {
        wavePoints.add(Offset(dx, dy));
      }
    }

    path.addPolygon(wavePoints, false);

    // finish the line
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(WaveClipper old) =>
      progress != old.progress || animation != old.animation;
}

class ContainerWrapper extends StatelessWidget {
  final Widget child;
  final double widthScale;

  ContainerWrapper({required this.child, this.widthScale = 0.8});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * widthScale,
      child: Container(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xe6ffffff),
              boxShadow: const [
                BoxShadow(color:  Color(0x28000000), blurRadius: 5.0)
              ],
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: child,
        ),
      ),
    );
  }
}
