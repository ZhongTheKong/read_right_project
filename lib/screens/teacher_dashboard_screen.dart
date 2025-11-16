import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatefulWidget {
  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  String? selectedStudent;
  String? selectedList;
  DateTime? selectedDate;

  // Example data
  final students = ['Alice', 'Bob', 'Charlie'];
  final lists = ['Math', 'Science', 'History'];
  final classOverview = [
    {'name': 'Alice', 'list': 'Math', 'date': '2025-11-15'},
    {'name': 'Bob', 'list': 'Science', 'date': '2025-11-16'},
    {'name': 'Charlie', 'list': 'History', 'date': '2025-11-17'},
  ];

  // Filter function
  List<Map<String, String>> get filteredOverview {
    return classOverview.where((item) {
      final matchStudent = selectedStudent == null || item['name'] == selectedStudent;
      final matchList = selectedList == null || item['list'] == selectedList;
      final matchDate = selectedDate == null || item['date'] == selectedDate!.toIso8601String().split('T')[0];
      return matchStudent && matchList && matchDate;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard v1'),
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
                  items: students
                      .map((student) => DropdownMenuItem(
                            value: student,
                            child: Text(student),
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
              child: ListView.builder(
                itemCount: filteredOverview.length,
                itemBuilder: (context, index) {
                  final item = filteredOverview[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['name']!),
                      subtitle: Text('List: ${item['list']} | Date: ${item['date']}'),
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
