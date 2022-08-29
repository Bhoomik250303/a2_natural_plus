import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceServices {
  static late SharedPreferences _preference;

  static Future settingPreference() async {
    _preference = await SharedPreferences.getInstance();
    // Fluttertoast.showToast(msg: 'pref alloted');
  }

  setListValue(List<String> val) {
    _preference.setStringList('cartList', val);
  }

  getListValue() {
    _preference.getStringList('cartList');
  }
}
