import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isEnabled = true;
  bool _breakfastReminder = true;
  bool _lunchReminder = true;
  bool _dinnerReminder = true;
  bool _waterReminder = false;
  
  TimeOfDay _breakfastTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _lunchTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _dinnerTime = const TimeOfDay(hour: 19, minute: 0);
  
  bool get isEnabled => _isEnabled;
  bool get breakfastReminder => _breakfastReminder;
  bool get lunchReminder => _lunchReminder;
  bool get dinnerReminder => _dinnerReminder;
  bool get waterReminder => _waterReminder;
  
  TimeOfDay get breakfastTime => _breakfastTime;
  TimeOfDay get lunchTime => _lunchTime;
  TimeOfDay get dinnerTime => _dinnerTime;
  
  void setEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }
  
  void setBreakfastReminder(bool value) {
    _breakfastReminder = value;
    notifyListeners();
  }
  
  void setLunchReminder(bool value) {
    _lunchReminder = value;
    notifyListeners();
  }
  
  void setDinnerReminder(bool value) {
    _dinnerReminder = value;
    notifyListeners();
  }
  
  void setWaterReminder(bool value) {
    _waterReminder = value;
    notifyListeners();
  }
  
  void setBreakfastTime(TimeOfDay time) {
    _breakfastTime = time;
    notifyListeners();
  }
  
  void setLunchTime(TimeOfDay time) {
    _lunchTime = time;
    notifyListeners();
  }
  
  void setDinnerTime(TimeOfDay time) {
    _dinnerTime = time;
    notifyListeners();
  }
}
