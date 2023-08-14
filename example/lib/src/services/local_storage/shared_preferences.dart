import 'dart:convert';

import 'package:face_camera_example/src/common/models/turntill.dart';
import 'package:face_camera_example/src/services/local_storage/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates an instance of the [SharedPreferenceHelper] class and assigns it to a variable called sharedPreference.
final sharedPreference = SharedPreferenceHelper();

class SharedPreferenceHelper {
  late SharedPreferences _sharedPreference;

  /// A method that initializes the `SharedPreferences` instance.
  initSharedPreferences() async {
    _sharedPreference = await SharedPreferences.getInstance();
  }

  /// A getter that returns the `_sharedPreference` instance.
  SharedPreferences get prefs => _sharedPreference;

  /// A method that clears all values in the `_sharedPreference` instance.
  Future<void> clearAll() async {
    await _sharedPreference.clear();
  }

  /// Methods for settings and getting `kChosenServer`
  String get chosenServer => _sharedPreference.getString(Preferences.kChosenServer) ?? '';
  Future setChosenServer(String value) async => await _sharedPreference.setString(Preferences.kChosenServer, value);

  /// Methods for settings and getting `kTurntillName`
  Turntill get turntill {
    Map<String, dynamic> jsonObject = json.decode(_sharedPreference.getString(Preferences.kTurntillName) ?? "");
    return Turntill.fromJson(json: jsonObject);
  }

  Future setTurntill(Turntill value) async => await _sharedPreference.setString(
        Preferences.kTurntillName,
        json.encode(
          value.toJson(),
        ),
      );
}
