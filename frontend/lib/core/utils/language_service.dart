import 'package:flutter/material.dart';

/// Simple i18n service — supports English (en) and Amharic (am).
/// Uses [ValueNotifier] so any widget can listen to language changes
/// without a state-management package.
class LanguageService {
  LanguageService._();

  static final ValueNotifier<String> languageNotifier =
      ValueNotifier<String>('en');

  static final Map<String, Map<String, String>> _texts = {
    'en': {
      'profile': 'Profile',
      'editProfile': 'Edit Profile',
      'payment': 'Payment Methods',
      'notifications': 'Notifications',
      'language': 'Language',
      'help': 'Help Center',
      'logout': 'Log Out',
      'recycled': 'Recycled',
      'pickups': 'Pickups',
      'level': 'Level 4 Recycler',
      'home': 'Home',
      'schedule': 'Schedule',
      'wallet': 'Wallet',
    },
    'am': {
      'profile': 'መገለጫ',
      'editProfile': 'መገለጫ አርትዕ',
      'payment': 'የክፍያ ዘዴዎች',
      'notifications': 'ማሳወቂያዎች',
      'language': 'ቋንቋ',
      'help': 'የእገዛ ማዕከል',
      'logout': 'ውጣ',
      'recycled': 'የተመለሰ',
      'pickups': 'መሰብሰቦች',
      'level': 'ደረጃ 4 መለስ',
      'home': 'ቤት',
      'schedule': 'መርሃ ግብር',
      'wallet': 'ቦርሳ',
    },
  };

  /// Translate [key] to the current language. Falls back to key itself.
  static String t(String key) {
    return _texts[languageNotifier.value]?[key] ?? key;
  }

  static void toggleLanguage() {
    languageNotifier.value =
        languageNotifier.value == 'en' ? 'am' : 'en';
  }

  static void setLanguage(String lang) {
    if (_texts.containsKey(lang)) {
      languageNotifier.value = lang;
    }
  }
}
