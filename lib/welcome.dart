import 'package:agri_food_freind/myData.dart';

import 'main.dart';
import 'welcome/cas.dart';
import '/welcome/center_next_button.dart';
import 'welcome/tap.dart';

import 'welcome/organic.dart';
import 'welcome/hi_view.dart';
import '/welcome/top_back_skip_view.dart';
import 'welcome/qrcode.dart';
import 'package:flutter/material.dart';

import 'welcome/sign.dart';

class Welcome extends StatefulWidget{
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() =>
      _WelcomeState();
      
 
}

class _WelcomeState
    extends State<Welcome> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_animationController?.value);
    return Scaffold(
      resizeToAvoidBottomInset:false,
      backgroundColor: MyTheme.color,
      body: ClipRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController!,
            ),
            RelaxView(
              animationController: _animationController!,
            ),
            CareView(
              animationController: _animationController!,
            ),
            MoodDiaryVew(
              animationController: _animationController!,
            ),
            WelcomeViewTwo(
              animationController: _animationController!,
            ),
            WelcomeView(
              animationController: _animationController!,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
              superContent: context,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.9,
        duration: Duration(milliseconds: 1200));
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.1) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.1 &&
        _animationController!.value <= 0.3) {
      _animationController?.animateTo(0.1);
    } else if (_animationController!.value > 0.3 &&
        _animationController!.value <= 0.5) {
      _animationController?.animateTo(0.3);
    } else if (_animationController!.value > 0.5 &&
        _animationController!.value <= 0.7) {
      _animationController?.animateTo(0.5);
    } else if (_animationController!.value > 0.7 &&
        _animationController!.value <= 0.9) {
      _animationController?.animateTo(0.7);
    } else if (_animationController!.value > 0.9 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.9);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.1) {
      _animationController?.animateTo(0.3);
    } else if (_animationController!.value > 0.1 &&
        _animationController!.value <= 0.3) {
      _animationController?.animateTo(0.5);
    } else if (_animationController!.value > 0.3 &&
        _animationController!.value <= 0.5) {
        _animationController?.animateTo(0.7);
    }else if (_animationController!.value > 0.5 &&
        _animationController!.value <= 0.7) {
        _animationController?.animateTo(0.9);
    }else if (_animationController!.value > 0.7 &&
        _animationController!.value <= 0.9) {
    }else if (_animationController!.value > 0.9 &&
        _animationController!.value <= 1.0) {
      _signUpClick();
    }
  }

  void _signUpClick() {
    Navigator.pop(context);
  }
}
