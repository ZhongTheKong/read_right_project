import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/teacher_user_data.dart';
import 'package:read_right_project/utils/user_data.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  @override
  void initState() {
    super.initState();
    _configureAudioSession();
  }

  @override
  Widget build(BuildContext context) {

    SessionProvider sessionProvider = context.read<SessionProvider>();
    AllUsersProvider allUsersProvider = context.read<AllUsersProvider>();
    final lastLoggedInUser = allUsersProvider.allUserData.lastLoggedInUser;
    print("last logged in user username: ${lastLoggedInUser == null ? 'null' : lastLoggedInUser.username}");
    print(lastLoggedInUser.runtimeType);


    return Scaffold(
      body: Column(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  sessionProvider.isTeacher = false;
                  if (lastLoggedInUser is StudentUserData) {
                    Navigator.pushReplacementNamed(context, AppRoutes.wordList);
                  }
                  else {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: LinearBorder()
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.child_care,
                        size: 60,
                        color: Colors.black,
                      ),
                      Text(
                        "Student",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  sessionProvider.isTeacher = true;
                  if (lastLoggedInUser is TeacherUserData) {
                    Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
                  }
                  else {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: LinearBorder()
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.black
                      ),
                      Text(
                        "Teacher",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
