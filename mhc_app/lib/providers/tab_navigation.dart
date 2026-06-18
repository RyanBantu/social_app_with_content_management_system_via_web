import 'package:flutter/material.dart';

class TabNavigation extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void selectTab(int i) {
    if (_index == i) return;
    _index = i;
    notifyListeners();
  }

  void goToEvents() => selectTab(3);
}
