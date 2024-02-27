import 'dart:convert';
import 'dart:developer';

import 'package:api_with_nodejs/repository/login_repo.dart';
import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  LoginRepo loginRepo = LoginRepo();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  login(dynamic body, BuildContext context) async {
    setLoading(true);
    loginRepo.login(body).then((value) {
      log(value);
      setLoading(false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Done")));
    }).onError((error, stackTrace) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())));
      setLoading(false);
    });
  }
}
