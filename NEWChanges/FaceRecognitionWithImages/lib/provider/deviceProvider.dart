import 'package:flutter/material.dart';

class DeviceInfoProvider with ChangeNotifier {
  String _deviceID = '';

  String get deviceID => _deviceID;

  void setDeviceID(String id) {
    _deviceID = id;
    notifyListeners(); // Notify widgets listening to this provider
  }

  String getDeviceId() {
    return deviceID;
    // Notify widgets listening to this provider
  }
}
