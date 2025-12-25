import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<Map<String, String>>> chats = {};

  void sendMessage(String user, String msg) {
    chats.putIfAbsent(user, () => []);
    chats[user]!.add({"type": "sender", "msg": msg});
    notifyListeners();
  }

  void addReceiverMessage(String user, String msg) {
    chats.putIfAbsent(user, () => []);
    chats[user]!.add({"type": "receiver", "msg": msg});
    notifyListeners();
  }
}