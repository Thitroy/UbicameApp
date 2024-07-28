import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUsers {
  // Generar la instancia
  static late SharedPreferences _prefs;

  // Inicializar las preferencias
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get lastPage {
    return _prefs.getString('lastPage') ?? 'splash';
  }

  set lastPage(String value) {
    _prefs.setString('lastPage', value);
  }

  String get lastuid {
    return _prefs.getString('lastuid') ?? '';
  }

  set lastuid(String value) {
    _prefs.setString('lastuid', value);
  }

  String get role {
    return _prefs.getString('role') ?? 'estudiante';
  }

  set role(String value) {
    _prefs.setString('role', value);
  }
}
