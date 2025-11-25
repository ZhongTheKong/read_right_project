import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

class TeacherDashboardScreen extends StatefulWidget {
  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  String? selectedStudent;
  String? selectedList;
  DateTime? selectedDate;

  // This will be populated from the provider
  List<StudentUserData> studentUsers = [];

  // This hardcoded list will be replaced
  final lists = ['Primer', 'Pre-Primer', 'First', 'Second', 'Third'];

  // --- REPLACED: This now filters the real student data ---
  List<StudentUserData> get filteredStudents {
    if (studentUsers.isEmpty) return [];

    return studentUsers.where((student) {
      // Match by student username
      final matchStudent = selectedStudent == null || student.username == selectedStudent;

      // Match by word list (This is a more complex filter for later)
      // For now, we'll just check if the student has any attempts.
      final matchList = selectedList == null || student.word_list_attempts.keys.any((key) => key.contains(selectedList!));

      // Match by date of any attempt (This is also complex)
      // For now, we will just return the student if the other filters match.
      // A more detailed implementation would iterate through all attempts.
      final matchDate = selectedDate == null; // Simplified for now

      return matchStudent; //&& matchList && matchDate;
    }).toList();
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
    // --- FIX 1: Get the AllUsersProvider ---
    AllUsersProvider allUsersProvider = context.watch<AllUsersProvider>();

    // --- FIX 2: Get the list of actual student users ---
    studentUsers = allUsersProvider.allUserData.studentUserDataList;

    // Create a list of student names for the dropdown
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
                // --- FIX 3: Use the dynamic list of student names ---
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
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: Text(selectedDate == null
                      ? 'Select Date'
                      : '${selectedDate!.toLocal()}'.split(' ')[0]),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Class Overview
            Expanded(
              // --- FIX 4: Build the list from the filtered real data ---
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  // You can now access any property of the StudentUserData object
                  // For example, let's find the total number of attempts.
                  final totalAttempts = student.word_list_attempts.values
                      .fold(0, (sum, list) => sum + list.length);

                  return Card(
                    child: ListTile(
                      title: Text(student.username),
                      subtitle: Text('Total Attempts: $totalAttempts'),
                      // You could add a trailing icon or button to navigate to a detailed view
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // TODO: Navigate to a detailed progress screen for this student
                      },
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
