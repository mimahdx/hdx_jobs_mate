import 'package:shared_preferences/shared_preferences.dart';

class FirstLaunchManager {
  static const String _isFirstLaunchKey = 'is_first_launch';

  final SharedPreferences sharedPreferences;

  FirstLaunchManager({required this.sharedPreferences});

  Future<bool> isFirstLaunch() async {
    return sharedPreferences.getBool(_isFirstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    await sharedPreferences.setBool(_isFirstLaunchKey, false);
  }
}