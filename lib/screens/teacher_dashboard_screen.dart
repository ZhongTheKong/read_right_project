import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/save_file_to_folder.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/attempt.dart';
import 'package:read_right_project/utils/routes.dart';


// --------------------------------------------
//  Teacher Dashboard Screen
//  Allows teachers to:
//    • Select a student
//    • Optionally filter by date
//    • View reading attempts
//    • Playback attempt recordings
// --------------------------------------------
class TeacherDashboardScreen extends StatefulWidget {
  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}


// -------------------------------------------------------
//  State class that manages dashboard filters + attempt
//  retrieval + UI rendering.
// -------------------------------------------------------
class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {

  // --------------------------
  // Filter state variables
  // --------------------------
  String? selectedStudent;
  String? selectedList;       // Currently unused, placeholder for future list filtering
  DateTime? selectedDate;

  // The list of all student users (populated via provider)
  List<StudentUserData> studentUsers = [];

  // -------------------------------------------------------------
  // PRE: studentUsers has been populated from AllUsersProvider.
  //      selectedStudent may be null (in which case result is []).
  //
  // This getter collects all Attempts for the selected student,
  // optionally filters by date, sorts them newest → oldest,
  // and returns the final list.
  //
  // POST: Returns a list of Attempts that match all active filters.
  // -------------------------------------------------------------
  List<Attempt> get filteredAttempts {
    if (studentUsers.isEmpty || selectedStudent == null) {
      return []; // No student selected → no results
    }

    try {
      // Safely locate the selected student
      final student = studentUsers.firstWhere((s) => s.username == selectedStudent);

      // Extract all attempts across word list progression datasets
      List<Attempt> allAttempts =
          student.word_list_progression_data.values.expand((list) => list.attempts).toList();

      // ----------------------
      // Apply date filtering
      // ----------------------
      if (selectedDate != null) {
        allAttempts = allAttempts.where((attempt) {
          final attemptDate = attempt.createdAt;

          // Match by exact day (year, month, day)
          return attemptDate.year == selectedDate!.year &&
                 attemptDate.month == selectedDate!.month &&
                 attemptDate.day == selectedDate!.day;
        }).toList();
      }

      // Sort newest to oldest
      allAttempts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return allAttempts;
    } catch (e) {
      // A fallback if something fails while finding the student
      print("Could not find the selected student: $selectedStudent. Error: $e");
      return [];
    }
  }


  // ------------------------------------------------------
  // PRE: User taps the "Select Date" button.
  //      A date picker is shown.
  //
  // POST: selectedDate is updated with the chosen date
  //       (or remains unchanged if user cancels)
  // ------------------------------------------------------
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


  // ---------------------------------------------------------
  // PRE: Providers must be available from above in widget tree.
  //      UI is rebuilt when filters or provider data change.
  //
  // Builds the entire teacher dashboard UI:
  //    • Dropdown to select student
  //    • Date filter
  //    • "Sign Out" + "Clear Filters"
  //    • List of attempts with playback controls
  //
  // POST: Returns a Scaffold containing the whole dashboard.
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    // Access all users from provider
    AllUsersProvider allUsersProvider = context.watch<AllUsersProvider>();
    SessionProvider sessionProvider = context.read<SessionProvider>();

    studentUsers = allUsersProvider.allUserData.studentUserDataList;

    // Extract usernames for dropdown
    final studentNames = studentUsers.map((student) => student.username).toList();

    // Access audio playback state
    RecordingProvider recordingProvider = context.watch<RecordingProvider>();


    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Teacher Dashboard'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedStudent = null;
                  selectedList = null;
                  selectedDate = null;
                });
                Navigator.pushNamed(context, AppRoutes.role);
              },
              child: Text("Sign Out"),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, AppRoutes.create_account);
            //   },
            //   child: Text(
            //     "Add Student",
            //     style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.bold
            //     ),
            //   ),
            // ),
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            // --------------------------
            // Student + Date Filter Row
            // --------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Student Dropdown
                DropdownButton<String>(
                  hint: Text('Select Student'),
                  value: selectedStudent,
                  items: studentNames.map((studentName) =>
                    DropdownMenuItem(
                      value: studentName,
                      child: Text(studentName),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStudent = value;
                    });
                  },
                ),

                // Date Picker Button
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: Text(
                    selectedDate == null
                      ? 'Select Date'
                      : '${selectedDate!.toLocal()}'.split(' ')[0]
                  ),
                ),
              ],
            ),

            // --------------------------
            // Sign out + Clear filters
            // --------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      sessionProvider.isCreateAccountTeacher = false;
                      Navigator.pushNamed(context, AppRoutes.create_account);
                    },
                    child: Text(
                      "Add Student",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  // child: TextButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       selectedStudent = null;
                  //       selectedList = null;
                  //       selectedDate = null;
                  //     });
                  //     Navigator.pushNamed(context, AppRoutes.role);
                  //   },
                  //   child: Text("Sign Out"),
                  // ),
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
              ]
            ),

            SizedBox(height: 10),

            // ------------------------------------------------
            // Attempts List
            //
            // PRE: selectedStudent is not null
            // POST: A scrollable list of attempts is shown.
            // ------------------------------------------------
            Expanded(
              child: selectedStudent == null
                ? Center(child: Text('Please select a student to see their attempts.'))
                : ListView.builder(
                    itemCount: filteredAttempts.length,
                    itemBuilder: (context, index) {
                      final attempt = filteredAttempts[index];

                      // Check if the audio file exists locally
                      final exists = File(attempt.filePath).existsSync();

                      return Card(
                        child: ListTile(
                          // Score avatar
                          leading: CircleAvatar(
                            child: Text('${attempt.score.toStringAsFixed(0)}'),
                            backgroundColor: attempt.score > 70
                                ? Colors.green
                                : Colors.orange,
                            foregroundColor: Colors.white,
                          ),

                          // Word attempted
                          title: Text(
                            attempt.word,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          // Attempt date
                          subtitle: Text(
                            'Date: ${attempt.createdAt.toLocal().toString().substring(0, 16)}'
                          ),

                          // Playback button
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow),
                            tooltip: 'Play Recording',

                            // Disable if playing or missing file
                            onPressed: (!exists || recordingProvider.isPlaying)
                                ? null
                                : () => recordingProvider.play(attempt.filePath),
                          ),
                        ),
                      );
                    },
                  ),
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await saveExistingJsonToUserLocation(context, await allUsersProvider.getUserDataFilePath(), 'saveFileCopy.json');
                    }, 
                    label: Text(
                      "SAVE CLASS DATA"
                    ),
                    icon: Icon(Icons.save)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
