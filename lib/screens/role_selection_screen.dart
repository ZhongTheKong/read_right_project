import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/routes.dart';

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

    return Scaffold(
      body: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () { 
                  sessionProvider.isTeacher = false;
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
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
