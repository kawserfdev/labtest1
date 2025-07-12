import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateChangeNotifierProvider = ChangeNotifierProvider((ref) {
  return StateChangeNotifier();
});

class StateChangeNotifier extends ChangeNotifier {
  bool _langChange = true;

  bool get langChange => _langChange;

  void setLangChange(bool change) {
    _langChange = change;
    notifyListeners();
  }
}
