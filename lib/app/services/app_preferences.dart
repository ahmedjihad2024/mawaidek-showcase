import 'dart:convert';

import 'package:mawadk/data/responses/responses.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

abstract class AbstractAppPreferences {
  Future<bool> setSkippedOnBoarding();
  Future<bool> resetOnBoarding();

  Future<void> setAccessToken(String accessToken);
  Future<void> setUserData(User user);

  Future<void> clearUserAndAccessToken();

  Future<void> reload();

  String? get accessToken;
  User? get userData;

  bool get isSkippedOnBoarding;

  bool get isUserRegistered;

  Future<void> saveLocationData({
    required double latitude,
    required double longitude,
    required String address,
  });

  Future<
      ({
        double? latitude,
        double? longitude,
        String? address,
      })> getLocationData();

  bool get isLocationSelected;

  bool get aiDisclaimerSeen;
  Future<void> setAiDisclaimerSeen();
}

class AppPreferences implements AbstractAppPreferences {
  final SharedPreferences _sharedPreferences;

  const AppPreferences(this._sharedPreferences);

  SharedPreferences get sharedPreferences => _sharedPreferences;

  @override
  Future<bool> resetOnBoarding() async =>
      await _sharedPreferences.setBool(Constants.skippedOnBoarding, false);

  @override
  Future<bool> setSkippedOnBoarding() async =>
      await _sharedPreferences.setBool(Constants.skippedOnBoarding, true);

  @override
  bool get isSkippedOnBoarding =>
      _sharedPreferences.getBool(Constants.skippedOnBoarding) ?? false;

  @override
  bool get isUserRegistered =>
      _sharedPreferences.getString(Constants.accessToken) != null;

  @override
  Future<void> clearUserAndAccessToken() async {
    await _sharedPreferences.remove(Constants.accessToken);
    await _sharedPreferences.remove(Constants.userData);
  }

  @override
  String? get accessToken =>
      _sharedPreferences.getString(Constants.accessToken);

  @override
  User? get userData {
    final userJsonString = _sharedPreferences.getString(Constants.userData);
    if (userJsonString == null) return null;
    try {
      final userJson = json.decode(userJsonString) as Map<String, dynamic>;
      return User.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setUserData(User user) async {
    final userJson = json.encode(user.toJson());
    await _sharedPreferences.setString(Constants.userData, userJson);
  }

  @override
  Future<void> reload() async => await _sharedPreferences.reload();

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _sharedPreferences.setString(Constants.accessToken, accessToken);
  }

  @override
  Future<void> saveLocationData({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    await _sharedPreferences.setDouble('user-latitude', latitude);
    await _sharedPreferences.setDouble('user-longitude', longitude);
    await _sharedPreferences.setString('user-address', address);
  }

  @override
  Future<
      ({
        double? latitude,
        double? longitude,
        String? address,
      })> getLocationData() async {
    final latitude = _sharedPreferences.getDouble('user-latitude');
    final longitude = _sharedPreferences.getDouble('user-longitude');
    final address = _sharedPreferences.getString('user-address');

    return (
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }

  @override
  bool get isLocationSelected {
    final latitude = _sharedPreferences.getDouble('user-latitude');
    final longitude = _sharedPreferences.getDouble('user-longitude');
    final address = _sharedPreferences.getString('user-address');

    // Return true if all location data is available
    return latitude != null &&
        longitude != null &&
        address != null &&
        address.isNotEmpty;
  }

  @override
  bool get aiDisclaimerSeen =>
      _sharedPreferences.getBool(Constants.aiDisclaimerSeen) ?? false;

  @override
  Future<void> setAiDisclaimerSeen() async {
    await _sharedPreferences.setBool(Constants.aiDisclaimerSeen, true);
  }
}
