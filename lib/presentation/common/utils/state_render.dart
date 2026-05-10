import 'package:flutter/material.dart';

enum ReqState { loading, empty, error, success, idle }

extension IsRequestState on ReqState {
  bool get isLoading => this == ReqState.loading;
  bool get isEmpty => this == ReqState.empty;
  bool get isError => this == ReqState.error;
  bool get isSuccess => this == ReqState.success;
  bool get isIdle => this == ReqState.idle;
}

class ScreenState {
  static Widget setState({
    required ReqState reqState,
    required Widget Function() online,
    Widget Function()? error,
    Widget Function()? loading,
    Widget Function()? empty,
    Widget Function()? idle,
  }) {
    return switch (reqState) {
      ReqState.success => online(),
      ReqState.loading => loading?.call() ?? const SizedBox.shrink(),
      ReqState.error => error?.call() ?? const SizedBox.shrink(),
      ReqState.empty => empty?.call() ?? const SizedBox.shrink(),
      ReqState.idle => idle?.call() ?? const SizedBox.shrink(),
      _ => const SizedBox.shrink(),
    };
  }
}
