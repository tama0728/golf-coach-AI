import 'package:flutter/material.dart';

class ProfileImageProvider extends ChangeNotifier {
  String _imagePath = 'assets/profile/profile1.png';

  String get imagePath => _imagePath;

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }
}