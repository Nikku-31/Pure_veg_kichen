import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageVM extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt("userId") ?? 0;

    final path = prefs.getString("profileImage_$userId");

    if (path != null && File(path).existsSync()) {
      _image = File(path);
    } else {
      _image = null;
    }

    notifyListeners();
  }

  Future<void> setImage(File image) async {
    _image = image;

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt("userId") ?? 0;

    await prefs.setString(
      "profileImage_$userId",
      image.path,
    );

    notifyListeners();
  }

  Future<void> clearImage() async {
    _image = null;
    notifyListeners();
  }
}