import 'dart:convert';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {};
  Map<String, dynamic> appointment = {};
  List<Map<String, dynamic>> favDoc = [];
  List<dynamic> _fav = [];

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

  List<Map<String, dynamic>> get getFavDoc {
    favDoc.clear();

    // Check if user contains 'doctor' key
    if (user.containsKey('doctor')) {
      for (var num in _fav) {
        for (var doc in user['doctor']) {
          if (doc.containsKey('doc_id') && num == doc['doc_id']) {
            favDoc.add(doc);
          }
        }
      }
    }
    return favDoc;
  }

  void loginSuccess(Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;
    user = userData ?? {};
    appointment = appointmentInfo ?? {};

    if (user.containsKey('details') && user['details'] != null && user['details']['fav'] != null) {
      _fav = json.decode(user['details']['fav']);
    } else {
      _fav = [];
    }

    notifyListeners();
  }

  void signupSuccess(Map<String, dynamic> userData) {
    _isLogin = true;
    user = userData ?? {};
    notifyListeners();
  }
}