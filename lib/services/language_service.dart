import 'package:flutter/material.dart';

class LanguageService {
  static ValueNotifier<String> languageNotifier =
      ValueNotifier<String>("en");

  static Map<String, Map<String, String>> texts = {
    "en": {
      "profile": "Profile",
      "editProfile": "Edit Profile",
      "payment": "Payment Methods",
      "notifications": "Notifications",
      "language": "Language",
      "help": "Help Center",
      "logout": "Log Out",
      "recycled": "Recycled",
      "pickups": "Pickups",
      "level": "Level 4 Recycler",
    },
    "am": {
      "profile": "መገለጫ",
      "editProfile": "መገለጫ አርትዕ",
      "payment": "የክፍያ ዘዴዎች",
      "notifications": "ማሳወቂያዎች",
      "language": "ቋንቋ",
      "help": "የእገዛ ማዕከል",
      "logout": "ውጣ",
      "recycled": "የተመለሰ",
      "pickups": "መሰብሰቦች",
      "level": "ደረጃ 4 መለስ",
    },
  };

  static String t(String key) {
    return texts[languageNotifier.value]![key]!;
  }

  static void toggleLanguage() {
    languageNotifier.value =
        languageNotifier.value == "en" ? "am" : "en";
  }
}
