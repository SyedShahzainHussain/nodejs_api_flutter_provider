import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:api_with_nodejs/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import "package:http_parser/src/media_type.dart";

class RegisterRepo with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? _image;

  File? get image => _image;

  setFile(File? image) {
    _image = image;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void pickImage() async {
    File? image = await Utils.pickImage();
    setFile(image);
  }

  getFileExtension(String image) {
    final List<String> ext = image.split(".");
    return ext.last;
  }

  Future<void> registerApi(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    setLoading(true);
    final imageExtension = getFileExtension(image!.path);
    final contentType = MediaType('image', imageExtension);
    const url = "http://10.0.2.2:8000/api/registers";

    final request = MultipartRequest(
      "POST",
      Uri.parse(url),
    );

    request.files.add(
      await MultipartFile.fromPath(
        "image",
        image!.path,
        contentType: contentType,
      ),
    );
    request.fields["name"] = name;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["confirmPassword"] = confirmPassword;

    final response = await request.send();
    if (response.statusCode == 201) {
      setLoading(false);
      String responseBody =
          await response.stream.transform(utf8.decoder).join();

      var jsonData = responseBody;
      log(jsonData);
    } else {
      setLoading(false);
      log("error");
    }
  }
}
