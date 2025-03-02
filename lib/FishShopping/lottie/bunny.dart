import 'package:flutter/material.dart';

class Bunny{
  Bunny(this.controller){
    setNeutralState();
  }

  AnimationController controller;

  //各种状态的起始和结束帧数
  static const List<int> _neutral_to_tracking =[4,22];
  static const List<int> _tracking_to_neutral = [0, 0];

  static const List<int> _neutral_to_shy = [29, 39];
  static const List<int> _shy_to_neutral = [44, 54];

  static const List<int> _neutral_to_peek = [76, 68];
  static const List<int> _peek_to_neutral = [68, 76];

  static const List<int> _shy_to_peek = [59, 68];
  static const List<int> _peek_to_shy = [68, 59];

  BunnyState currentState=BunnyState.neutral;

  void setNeutralState(){
    switch(currentState){
      case BunnyState.neutral:
        return;
      case BunnyState.tracking:
        setMinMaxFrame(_tracking_to_neutral);
        break;
      case BunnyState.shy:
        setMinMaxFrame(_shy_to_neutral);
        break;
      case BunnyState.peek:
        setMinMaxFrame(_peek_to_neutral);
        break;
    }
    currentState = BunnyState.neutral;
  }

  void setShyState() {
    switch(currentState) {
      case BunnyState.neutral:
      case BunnyState.tracking:
        setMinMaxFrame(_neutral_to_shy);
        break;
      case BunnyState.shy:
        return;
      case BunnyState.peek:
        setMinMaxFrame(_peek_to_shy);
        break;
    }

    currentState = BunnyState.shy;
  }

  void setPeekState() {
    switch(currentState) {
      case BunnyState.neutral:
      case BunnyState.tracking:
        setMinMaxFrame(_neutral_to_peek);
        break;
      case BunnyState.shy:
        setMinMaxFrame(_shy_to_peek);
        break;
      case BunnyState.peek:
        return;
    }

    currentState = BunnyState.peek;
  }

  void setTrackingState() {
    switch(currentState) {
      case BunnyState.neutral:
        setMinMaxFrame(_tracking_to_neutral);
        break;
      case BunnyState.tracking:
        return;
      case BunnyState.shy:
        setMinMaxFrame(_shy_to_neutral);
        break;
      case BunnyState.peek:
        setMinMaxFrame(_peek_to_neutral);
        break;
    }

    currentState = BunnyState.tracking;
  }

  void setEyesPosition(double progress){
    if(currentState != BunnyState.tracking){
      setMinMaxFrame(_tracking_to_neutral);
      currentState = BunnyState.tracking;
      return;
    }
    if(progress>1){
      return;
    }
    final double frame=(_neutral_to_tracking[1] - _neutral_to_tracking[0])*progress;
    controller.animateTo(framesToPercentage(frame.toInt() + _neutral_to_tracking[0]),duration: Duration.zero);
  }

  void setMinMaxFrame(List<int> frames){
    controller.animateTo(framesToPercentage(frames[0]),duration: Duration.zero);
    controller.animateTo(framesToPercentage(frames[1]));
  }

  double framesToPercentage(int frame){
    return frame / 77;
  }
}


enum BunnyState{
  neutral,//默认状态
  tracking,//跟踪状态
  shy,//害羞状态
  peek//偷看状态
}