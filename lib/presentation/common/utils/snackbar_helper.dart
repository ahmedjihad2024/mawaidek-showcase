import 'package:mawadk/presentation/common/utils/toast.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mawadk/app/app.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/app/extensions.dart';
import 'package:mawadk/presentation/res/color_manager.dart';

class SnackbarHelper {
  static void showMessage(String message, ErrorMessage type,
      {int snackbarSeconds = 6, bool isError = false}) {
    if (type.isSnackBar) {
      _showSnackbar(message, snackbarSeconds, isError);
    } else {
      _showToast(message);
    }
  }

  static void _showSnackbar(String message,
      [int snackbarSeconds = 3, bool isError = false]) {
    try {
      showSnackBar(
          msg: message,
          context: NAVIGATOR_KEY.currentState!.context,
          seconds: snackbarSeconds);
    } catch (e) {
      print("ERROR: $e");
      // If snackbar fails, fallback to toast
      _showToast(message);
    }
  }

  static void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: ColorM.purple,
      textColor: Colors.white,
      fontSize:
          SCAFFOLD_MESSENGER_KEY.currentContext?.labelMedium.fontSize ?? 14,
    );
  }
}
