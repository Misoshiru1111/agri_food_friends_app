import 'package:agri_food_freind/history/camera.dart';
import 'package:agri_food_freind/history/camera_del.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../myData.dart';
// import 'package:simple_permissions/simple_permissions.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key, this.animationController, required this.userName})
      : super(key: key);
  final String userName;
  final AnimationController? animationController;
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  int _page = 0;
  List? _camera;

  Widget logoBtn(String pgFile, Function f) {
    return (SizedBox(
      height: MediaQuery.of(context).size.width * 0.3,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _page = 1;
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        child: Image.asset(pgFile),
      ),
    ));
  }

  getCameras() {
    return _camera;
  }

  @override
  void initState() {
    print(_page);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: FitnessAppTheme.background,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.transparent,
        body: getMainUI(),
        // floatingActionButton: ,
      ),
    );
  }

  Widget getMainUI() {
    if (_page == 0) {
      return (Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                logoBtn('images/cas.png', () {}),
                logoBtn('images/organic.png', () {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                logoBtn('images/qrcode.png', () {
                  print(_page);
                }),
                logoBtn('images/tap.png', () {}),
              ],
            ),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               Padding(padding: EdgeInsets.all(30)
               ,child:  
                ElevatedButton(
                          style:ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.dartColor
                          ), 
            
                  onPressed: () {},
                  child: Text('歷程紀錄'),
                ),)
              ],
            )
          ]));
    } else if (_page == 1) {
      return (Camera(
        userName: widget.userName,
      ));
    } else {
      return (Text("this is wrong"));
    }
  }
}
