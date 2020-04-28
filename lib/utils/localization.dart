import 'dart:async';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/services/hive/index.dart';

class LocalizationUtil {
  Locale _locale;
  Map<String, dynamic> _localizedStrings;
  VoidCallback _onLocaleChangedCallback;

  Future<void> init() async {
    await setPreferredLanguage();
  }

  dynamic translate(String text) {
    return (_localizedStrings == null || _localizedStrings[text] == null)
        ? '** $text not found'
        : _localizedStrings[text];
  }

  Locale _languageToLocale(String language) {
    if (language == null)
      language = hiveService.settings.getPreferredLanguage();
    if (language == null) return Consts.DEFAULT_LOCALE;
    Locale locale = Consts.LOCALES
        .firstWhere((Locale locale) => locale.languageCode == language);
    if (locale == null) return Consts.DEFAULT_LOCALE;
    return locale;
  }

  Future<void> _loadTranslations() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${_locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value);
    });
  }

  Future<void> setPreferredLanguage([String language]) async {
    _locale = _languageToLocale(language);
    await _loadTranslations();
    hiveService.settings.setPreferredLanguage(language);
    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }
  }

  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  get locale => _locale;

  get isRtl => _locale.languageCode == "he";

  static final LocalizationUtil _translations =
      new LocalizationUtil._internal();
  factory LocalizationUtil() {
    return _translations;
  }
  LocalizationUtil._internal();
}

LocalizationUtil localizationUtil = new LocalizationUtil();
