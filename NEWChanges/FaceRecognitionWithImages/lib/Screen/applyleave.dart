import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../API/applyleaveapi.dart';
import '../API/loginapi.dart';
import '../provider/userIdProvider.dart';

class ApplyLeaveScreen extends StatefulWidget {
  @override
  _ApplyLeaveScreenState createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedLeaveType;
  final List<String> leaveTypes = [
    'Casual Leave',
    'Maternity Leave',
    'Privilege Leave',
    'Restricted Holiday',
    'Special Casual Leave',
    'Special Covid Leave',
  ];
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Leave'),
        backgroundColor: Colors.grey,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date Picker
            Text('Start Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context, true),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color.fromARGB(255, 13, 149, 156)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Text(
                  startDate != null
                      ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                      : 'Select Start Date',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 16),

            // End Date Picker
            Text('End Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color.fromARGB(255, 13, 149, 156)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Text(
                  endDate != null
                      ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                      : 'Select End Date',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Leave Type Dropdown
            Text('Leave Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedLeaveType,
              onChanged: (value) {
                setState(() {
                  selectedLeaveType = value;
                });
              },
              items: leaveTypes.map((leaveType) {
                return DropdownMenuItem<String>(
                  value: leaveType,
                  child: Text(leaveType),
                );
              }).toList(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: Text('Select Leave Type', style: TextStyle(color: Colors.black54)),
            ),
            SizedBox(height: 16),

            // Reason TextField
            Text('Reason', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextFormField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Enter the reason for leave',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 52, 197, 197),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Submit', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (startDate != null &&
        endDate != null &&
        selectedLeaveType != null &&
        reasonController.text != null) {
      // Handle the form submission logic here
       String formattedStartDate = "${startDate!.year}-${startDate!.month}-${startDate!.day}";
    String formattedEndDate = "${endDate!.year}-${endDate!.month}-${endDate!.day}";
      String? userIdString =
          Provider.of<EmployeeProvider>(context, listen: false).employeeId;
      String reasontext = reasonController.text;
      print(
          'Leave Applied: $selectedLeaveType from $startDate to $endDate $reasontext');
      Leaveapply.applyleave(
        context: context,
        empId: userIdString,
        fromDate: formattedStartDate,
        toDate: formattedEndDate,
        leaveType: selectedLeaveType!,
        reason: reasonController.text,
      );
    } else {
      // Show a message if form is incomplete
      print('Please complete all fields');
    }
  }
}
