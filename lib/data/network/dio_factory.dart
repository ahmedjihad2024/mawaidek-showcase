import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mawadk/app/app.dart';
import 'package:mawadk/app/constants.dart';
import 'package:mawadk/presentation/common/ui_components/deactivated_account_dialog.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/services/app_preferences.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String AUTHORIZATION = 'authorization';
const String DEFAULT_LANGUAGE = 'Accept-Language';

enum RequestMethod { GET, POST, PUT, DELETE, PATCH }

class DioFactory {
  late Dio _dio;
  AppPreferences _appPreferences;
  bool isForNotification;

  Dio get dio => _dio;

  DioFactory(this._appPreferences, {this.isForNotification = false}) {
    _dio = Dio();

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: 'Bearer ${_appPreferences.accessToken}',
      DEFAULT_LANGUAGE: 'en',
      "Accept-Secret-Key": "zAyuqt8Fb#-DUMMY-SECRET-KEY" // wrong key for portfolio
    };

    _dio.options = BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        followRedirects: false,
        receiveDataWhenStatusError: true);

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (_appPreferences.accessToken != null) {
        options.headers['Authorization'] = 'Bearer ${_appPreferences.accessToken}';
      } else {
        options.headers.remove('Authorization');
      }
      if (SCAFFOLD_MESSENGER_KEY.currentState != null) {
        options.headers[DEFAULT_LANGUAGE] =
            EasyLocalization.of(SCAFFOLD_MESSENGER_KEY.currentState!.context)
                    ?.currentLocale
                    ?.languageCode ??
                'en';
      }
      return handler.next(options);
    }, onResponse: (response, handler) async {
      // Backend returns HTTP 200 with code: 403 in the body for deactivated accounts
      if (response.data is Map && response.data['code'] == 403 && !isForNotification) {
        await _appPreferences.clearUserAndAccessToken();
        await _appPreferences.sharedPreferences.reload();
        if (NAVIGATOR_KEY.currentState != null) {
          NAVIGATOR_KEY.currentState?.pushNamedAndRemoveUntil(
            RoutesManager.signIn.route, (_) => false,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final ctx = NAVIGATOR_KEY.currentContext;
            if (ctx != null) {
              showDeactivatedAccountDialog(ctx);
            }
          });
        }
      }
      return handler.next(response);
    }));

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true));
    }
  }

  Future<Response> request(String path,
      {RequestMethod method = RequestMethod.GET,
      Map<String, dynamic>? queryParameters,
      Object? body,
      Map<String, dynamic>? headers}) async {
    return await _dio.request(path,
        data: body,
        queryParameters: queryParameters,
        options: Options(method: method.name, headers: headers));
  }
}
