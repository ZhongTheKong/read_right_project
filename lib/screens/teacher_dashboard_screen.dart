import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/attempt.dart';

class TeacherDashboardScreen extends StatefulWidget {
  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  String? selectedStudent;
  String? selectedList;
  DateTime? selectedDate;

  List<StudentUserData> studentUsers = [];

  //final lists = ['Primer', 'Pre-Primer', 'First', 'Second', 'Third'];

  List<Attempt> get filteredAttempts {
    if (studentUsers.isEmpty || selectedStudent == null) {
      return []; // Return an empty list if no student is selected
    }
    // Use a try-catch block to safely find the student ---
    try {
      final student = studentUsers.firstWhere((s) => s.username == selectedStudent);
      List<Attempt> allAttempts = student.word_list_attempts.values.expand((list) => list).toList();
      // Data Filter
      if (selectedDate != null) {
        allAttempts = allAttempts.where((attempt) {
          final attemptDate = attempt.createdAt;
          // Compare year, month, and day to match the entire day
          return attemptDate.year == selectedDate!.year &&
              attemptDate.month == selectedDate!.month &&
              attemptDate.day == selectedDate!.day;
        }).toList();
      }

      allAttempts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return allAttempts;
    } catch (e) {
      // If firstWhere throws an error (student not found), catch it and return an empty list.
      print("Could not find the selected student: $selectedStudent. Error: $e");
      return [];
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AllUsersProvider allUsersProvider = context.watch<AllUsersProvider>();
    studentUsers = allUsersProvider.allUserData.studentUserDataList;
    final studentNames = studentUsers.map((student) => student.username).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: Text('Select Student'),
                  value: selectedStudent,
                  items: studentNames // Use the list of names from the provider
                      .map((studentName) => DropdownMenuItem(
                    value: studentName,
                    child: Text(studentName),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStudent = value;
                    });
                  },
                ),
                /*
                DropdownButton<String>(
                  hint: Text('Select List'),
                  value: selectedList,
                  items: lists
                      .map((list) => DropdownMenuItem(
                    value: list,
                    child: Text(list),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedList = value;
                    });
                  },
                ),
                */
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: Text(selectedDate == null
                      ? 'Select Date'
                      : '${selectedDate!.toLocal()}'.split(' ')[0]),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedStudent = null;
                    selectedList = null;
                    selectedDate = null;
                  });
                },
                child: Text("Clear Filters"),
              ),
            ),

            SizedBox(height: 10),
            Expanded(
              child: selectedStudent == null
                  ? Center(child: Text('Please select a student to see their attempts.'))
                  : ListView.builder(
                itemCount: filteredAttempts.length,
                itemBuilder: (context, index) {
                  final attempt = filteredAttempts[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${(attempt.score).toStringAsFixed(0)}'),
                        backgroundColor: attempt.score > 70 ? Colors.green : Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      title: Text(attempt.word, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Date: ${attempt.createdAt.toLocal().toString().substring(0, 16)}'),
                      // You could add a play button here later if needed
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}