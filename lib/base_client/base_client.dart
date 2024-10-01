import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app17000ft_new/base_client/app_exception.dart';
import 'package:app17000ft_new/utils/general_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/general_screen.dart';
import 'app_exception.dart';

class BaseClient {
  static const int TIME_OUT = 30;

  //GET Method
  Future<dynamic> get(String baseUrl, String api) async {
    var url = Uri.parse(baseUrl + api);
    try {
      var response =
          await http.get(url).timeout(const Duration(seconds: TIME_OUT));
      return _processResponse(response);
    } on SocketException {
      throw ExceptionClass(
          message: 'No Internet Connection',
          assetsUrl: 'assets/noInternet.webp',
          buttonText: 'Try again');
    } on TimeoutException {
      throw ExceptionClass(
          message: 'Request Timed Out',
          assetsUrl: 'assets/timeout.webp',
          buttonText: 'Try again');
    } on FormatException {
      throw ExceptionClass(
          message: 'Response Format Error',
          assetsUrl: 'assets/noInternet.webp',
          buttonText: 'Contact to the IT support team');
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  //POST Method
  Future<dynamic> post(String baseUrl, String api, dynamic payloadObj) async {
    var url = Uri.parse(baseUrl + api);
    try {
      var response = await http
          .post(url, body: payloadObj)
          .timeout(const Duration(seconds: TIME_OUT));
      return _processResponse(response);
    } on SocketException {
      throw ExceptionClass(
          message: 'No Internet Connection',
          assetsUrl: 'assets/noInternet.webp',
          buttonText: 'Try again');
    } on TimeoutException {
      throw ExceptionClass(
          message: 'Request Timed Out',
          assetsUrl: 'assets/timeout.webp',
          buttonText: 'Try again');
    } on FormatException {
      throw ExceptionClass(
          message: 'Response Format Error',
          assetsUrl: 'assets/noInternet.webp',
          buttonText: 'Contact to the IT support team');
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
        throw ApiNotResponsdingException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 404:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      default:
        throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
// last fetched data is not coming when user is offline
  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Exit Confirmation'),
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              exit(0);
              // Navigator.of(context).pop(true); // Return true to allow popping
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<bool> showLeaveConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Exit Confirmation'),
        content: const Text('Are you sure you want to leave this screen?'),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              //exit(0);
              Navigator.of(context).pop(true); // Return true to allow popping
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<bool> showConfirmationDialog(
      BuildContext context, VoidCallback onConfirm) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false when canceled
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true when confirmed
            },
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        onConfirm(); // Execute the passed onConfirm callback
      }
      return confirmed ?? false;
    });
  }

  // Future<bool>  showConfirmationDialog(BuildContext context,) async{
  //  return await  showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Confirm Submission'),
  //       content: const Text('Are you sure you want to submit?'),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('Cancel'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         TextButton(
  //           child: const Text('Confirm'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             // Handle the submission logic here
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Form Submitted')),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              //LoginController().logout(); // exit(0);
              // Navigator.of(context).pop(true); // Return true to allow popping
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
