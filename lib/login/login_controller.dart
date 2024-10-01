import 'dart:convert';
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:flutter/material.dart';
import '../base_client/app_exception.dart';
import '../base_client/baseClient_controller.dart';
import '../helper/dialog_helper.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with BaseController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  authUser(String? username,String? password) async {
    var request = {'username': username ?? '', 'password': password ?? ''};
    showLoading('Please wait...');
    var response = await BaseClient()
        .post('https://mis.17000ft.org/apis/fast_apis/','login.php', request)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        DialogHelper.showErrorDialog(description: apiError["reason"]);
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    var myresp = json.decode(response);
    hideLoading();

    return myresp;
  }

  clearFields() {
    usernameController.clear();
    phoneController.clear();
    passwordController.clear();
  }
}