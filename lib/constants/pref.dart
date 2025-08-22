import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  final pref = SharedPreferences.getInstance();
  // Write Data
  Future writeData({required String key, required String value}) async {
    SharedPreferences sharedPreferences = await pref;
    return await sharedPreferences.setString(key, value);
  }

  // Read Data
  Future readData({required String key}) async {
    SharedPreferences sharedPreferences = await pref;
    return sharedPreferences.getString(key);
  }

  // Write Integer value
  Future writeInt({required String key, required int value}) async {
    SharedPreferences sharedPreferences = await pref;
    return await sharedPreferences.setInt(key, value);
  }

  // Read Integer value
  Future readInt({required String key}) async {
    SharedPreferences sharedPreferences = await pref;
    return sharedPreferences.getInt(key);
  }

  // Set Boolean value
  Future setBool({required String key, required bool value}) async {
    SharedPreferences sharedPreferences = await pref;
    return await sharedPreferences.setBool(key, value);
  }

  // Read Boolean value
  Future readBool({required String key}) async {
    SharedPreferences sharedPreferences = await pref;
    return sharedPreferences.getBool(key);
  }

  // Remove Data one by one
  Future removeData(String key) async {
    SharedPreferences sharedPreferences = await pref;
    return sharedPreferences.remove(key);
  }

  // Remove all
  Future removeAll() async {
    SharedPreferences sharedPreferences = await pref;
    return sharedPreferences.clear();
  }
}
