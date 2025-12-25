import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  final List<String> users = [];

  void addUser(String name) {
    users.add(name);
    notifyListeners();
  }

}