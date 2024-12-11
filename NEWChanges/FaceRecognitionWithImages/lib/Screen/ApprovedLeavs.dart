import 'package:flutter/material.dart';
import 'package:geofence/API/loginapi.dart';
import 'package:geofence/API/shiftscheduleapi.dart';
import 'package:provider/provider.dart';

import '../API/applyleaveapi.dart';
import '../provider/userIdProvider.dart';

class leavesSchedule extends StatefulWidget {
  const leavesSchedule({super.key});

  @override
  State<leavesSchedule> createState() => _leavesScheduleState();
}

class _leavesScheduleState extends State<leavesSchedule> {
  List<Map<String, dynamic>> leavesData = [];

  @override
  void initState() {
    super.initState();
    leavesdata(); // Fetch shift data when the widget is initialized
  }

  // Function to fetch the shift data
  leavesdata() async {
    String? userIdString = Provider.of<EmployeeProvider>(context, listen: false).employeeId;

    if (userIdString != null) {
      try {
        // Fetch shift data by calling the API
        List<Map<String, dynamic>> leaves =
            await Leaveapply.leavesByEmpId(int.parse(userIdString));

        // Update the state with the fetched data
        setState(() {
          leavesData = leaves;
          print("shiftData: $leavesData");
        });
      } catch (e) {
        // Handle any errors that occur during the API call
        print('Error fetching shift data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Leaves Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: ListView.builder(
        itemCount: leavesData.length,
        itemBuilder: (context, index) {
          String startTime = leavesData[index]['fromDate'] ?? 'N/A';
          String endTime = leavesData[index]['toDate'] ?? 'N/A';
          String Reason = leavesData[index]['reason'] ?? 'Unknown';
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leavesData[index]['isApproved']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          leavesData[index]['leaveType']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          leavesData[index]['fromDate'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),

                        SizedBox(height: 4),
                        Text(
                          'Time: $startTime - $endTime',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        // Dynamically display the location
                        Text(
                          'Reason: $Reason',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
