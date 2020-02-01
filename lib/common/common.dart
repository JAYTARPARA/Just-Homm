import 'package:justhomm/common/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  readData(readKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = readKey;
    final value = prefs.getString(key) ?? '';
    // print('read: $value');
    return value;
  }

  writeData(writeKey, writeValue) async {
    final prefs = await SharedPreferences.getInstance();
    final key = writeKey;
    final value = writeValue;
    prefs.setString(key, value);
    // print('saved $value');
    return value;
  }

  logOut() async {
    writeData('loggedin', '');
    writeData('sid', '');
    writeData('mobile', '');
    writeData('userrole', '');
    API().logout();
  }

  clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
