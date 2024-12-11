import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class Leaveapply {
  static Future<void> applyleave({
    required BuildContext context,
    required String empId,
    required String fromDate,
    required String toDate,
    required String leaveType,
    required String reason,
  }) async {
    var applyleaveapi =
        "http://164.100.112.121/GeoFenceAttendenceNew/api/apply";
    final apiUrl = Uri.parse(applyleaveapi);
    print(applyleaveapi);

    var requestUrl = apiUrl.replace(queryParameters: {
      "empId": empId,
      "fromDate": fromDate,
      "toDate": toDate,
      "leaveType": leaveType,
      "reason": reason,
    });
    print(requestUrl);
    try {
      final response = await http.post(
        requestUrl,
        headers: {'Content-Type': 'application/json'},
      );
      // print(response.statusCode);
      // print("RESPONCESS");
      // print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/welcomescreen');
      } else {
        // Handle error when the server responds with an error status code
        print('Error: ${response.statusCode}');
        // Show an error message to the user
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error: $error');
      // Show an error message to the user
    }
  }

  ///get shift data
  static Future<List<Map<String, dynamic>>> leavesByEmpId(int empId) async {
    // Define the API URL
    final apiUrl = Uri.parse(
        "http://164.100.112.121/GeoFenceAttendenceNew/api/leavesdata/$empId");
    print(apiUrl);
    try {
      final response = await http.get(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> responseData = jsonDecode(response.body);

        // Extract shift data as a list of maps
        List<Map<String, dynamic>> leaves = responseData.map((leaves) {
          return {
            "empId": leaves['empId'], // Convert empId to int
            "fromDate": leaves['fromDate'],
            "toDate": leaves['toDate'],
            "isApproved": leaves['isApproved'],
            "leaveType": leaves['leaveType'],
            "reason": leaves['reason'],
            "isHalfDay": leaves['isHalfDay'],
            "isRejected": leaves['isRejected'],
          };
        }).toList();
        print("leaves :$leaves");
        return leaves;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }
}
