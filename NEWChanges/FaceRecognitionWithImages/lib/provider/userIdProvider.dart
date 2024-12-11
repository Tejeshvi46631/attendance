import 'package:flutter/material.dart';

class EmployeeProvider with ChangeNotifier {
  String _employeeId = '';

  String get employeeId => _employeeId;

  void setEmployeeId(String id) {
    _employeeId = id;
    notifyListeners();
  }
}
