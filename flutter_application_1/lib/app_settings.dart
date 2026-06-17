import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {

  bool isDark = false;

  String language = "English";

  bool notificationsEnabled = true;

  bool focusReminderEnabled = true;

  void changeTheme(bool value) {

    isDark = value;

    notifyListeners();
  }

  void changeLanguage(String value) {

    language = value;

    notifyListeners();
  }

  void changeNotification(bool value) {

    notificationsEnabled = value;

    notifyListeners();
  }

  void changeReminder(bool value) {

    focusReminderEnabled = value;

    notifyListeners();
  }

  String text({
    required String english,
    required String spanish,
  }) {

    if (language == "Spanish") {

      return spanish;
    }

    return english;
  }
}