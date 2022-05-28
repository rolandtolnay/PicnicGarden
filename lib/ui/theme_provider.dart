import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:shared_preferences/shared_preferences.dart';

const _storageKeyIsDarkMode = 'isDarkMode';

abstract class ThemeModeProvider extends ChangeNotifier {
  ThemeMode get themeMode;
  void setThemeMode(ThemeMode mode);
}

@LazySingleton(as: ThemeModeProvider)
class ThemeModeProviderImpl extends ChangeNotifier
    implements ThemeModeProvider {
  final SharedPreferences _preferences;

  late ThemeMode _themeMode;

  ThemeModeProviderImpl({required SharedPreferences preferences})
      : _preferences = preferences {
    _themeMode = _preferences.storedThemeMode ?? ThemeMode.system;
  }

  @override
  ThemeMode get themeMode => _themeMode;

  @override
  void setThemeMode(ThemeMode mode) {
    if (mode.isDarkMode == null) {
      _preferences.remove(_storageKeyIsDarkMode);
    } else {
      _preferences.setBool(_storageKeyIsDarkMode, mode.isDarkMode!);
    }
    _themeMode = mode;
    notifyListeners();
  }
}

extension on SharedPreferences {
  ThemeMode? get storedThemeMode {
    final isDarkMode = getBool(_storageKeyIsDarkMode);
    if (isDarkMode == null) return null;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}

extension on ThemeMode {
  bool? get isDarkMode {
    switch (this) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      default:
        return null;
    }
  }
}
