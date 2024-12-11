import 'package:flutter/material.dart';
import 'package:geofence/API/loginapi.dart';
import 'package:geofence/API/shiftscheduleapi.dart';
import 'package:geofence/themes/appcolor.dart';
import 'package:provider/provider.dart';

import '../provider/userIdProvider.dart';

class shiftSchedule extends StatefulWidget {
  const shiftSchedule({super.key});

  @override
  State<shiftSchedule> createState() => _shiftScheduleState();
}

class _shiftScheduleState extends State<shiftSchedule> {
  List<Map<String, dynamic>> shiftData = [];

  @override
  void initState() {
    super.initState();
    shiftScheduleData(); // Fetch shift data when the widget is initialized
  }

  // Function to fetch the shift data
  shiftScheduleData() async {
    String? userIdString =Provider.of<EmployeeProvider>(context, listen: false).employeeId;

    if (userIdString != null) {
      try {
        // Fetch shift data by calling the API
        List<Map<String, dynamic>> shifts =
            await ShiftSchedule.shiftByEmpId(int.parse(userIdString));

        // Update the state with the fetched data
        setState(() {
          shiftData = shifts;
          print("shiftData: $shiftData");
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
            'Shift Schedule',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return ListView.builder(
            itemCount: shiftData.length,
            itemBuilder: (context, index) {
              String startTime = shiftData[index]['startTime'] ?? 'N/A';
              String endTime = shiftData[index]['endTime'] ?? 'N/A';
              String location = shiftData[index]['location'] ?? 'Unknown';

              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.05,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shiftData[index]['day']!,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              shiftData[index]['remark']!,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              shiftData[index]['startDate']!,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Time: $startTime - $endTime',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Location: $location',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/leave');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(screenWidth * 0.25, screenHeight * 0.05),
                          ),
                          child: Text(
                            'Apply for Leave',
                            style: TextStyle(fontSize: screenWidth * 0.020),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
