import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:send_to_background/send_to_background.dart';

class DoubleBackToExitWidget<T> extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration duration;

  const DoubleBackToExitWidget({
    super.key,
    required this.child,
    this.message = 'Press back again to exit',
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<DoubleBackToExitWidget<T>> createState() =>
      _DoubleBackToExitWidgetState<T>();
}

class _DoubleBackToExitWidgetState<T> extends State<DoubleBackToExitWidget<T>> {
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope<T>(
      canPop: false, // block automatic pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();

        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > widget.duration) {
          _lastBackPressed = now;

          Fluttertoast.showToast(
            msg: widget.message,
            toastLength: Toast.LENGTH_SHORT,
          );
        } else {
          SendToBackground.sendToBackground();
        }
      },
      child: widget.child,
    );
  }
}
