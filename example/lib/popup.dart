import 'dart:ui';

import 'package:flutter/material.dart';

class Popup extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);
  Widget child;
  final Color? bgColor;

  Popup({
    required this.child,
    this.bgColor,
  });

  @override
  Color get barrierColor =>
      bgColor != null ? bgColor! : Colors.black.withAlpha(127);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}


class PopupDjando extends StatelessWidget{
  final Widget child;
  final Function? onClick; //点击child事件
  final double left; //距离左边位置
  final double top; //距离上面位置

  PopupDjando({
    required this.child,
    this.onClick,
    this.left = 0,
    this.top = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent, child: GestureDetector(child: Stack(
      children: <Widget>[
        Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, color: Colors.transparent,),
        Positioned(child: GestureDetector(child: child, onTap: (){ //点击子child
          if(onClick != null){
            Navigator.of(context).pop();
            onClick!();
          }
        }),
          left: left,
          top: top,),
      ],
    ),
      onTap: (){ //点击空白处
        Navigator.of(context).pop();
      },
    ),);
  }

}
