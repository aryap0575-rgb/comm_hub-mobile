import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

class MainController {
  static final MainController _singleton = MainController._internal();

  factory MainController() {
    return _singleton;
  }

  MainController._internal();

  // final scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController();

  final customPopupMenuController = CustomPopupMenuController();

  final naveListener = StreamController<int>.broadcast();
}
