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
    // print("last logged in user username: ${lastLoggedInUser == null ? 'null' : lastLoggedInUser.username}");
    // print(lastLoggedInUser.runtimeType);

    print("Role selection screen opened");

    return FutureBuilder<void>(
      future: (() async {
        final path = await allUsersProvider.getUserDataFilePath();
        return allUsersProvider.loadUserData(path);
      })(),
      builder: (context, snapshot) {
        
        //
        // 1. WAITING
        //
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("waiting");
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        //
        // 2. ERROR
        //
        if (snapshot.hasError) {
          print("Snapshot has error");
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.error.toString(),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Force rebuild by creating a new future
                          // (context as Element).markNeedsBuild();
                          setState(() {});
                        },
                        child: Text("Retry"),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          allUsersProvider.saveCurrentUserData();
                          // Force rebuild by creating a new future
                          // (context as Element).markNeedsBuild();
                          setState(() {});
                        },
                        child: Text("Create New Save File"),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () {
                          allUsersProvider.quarantineCorruptFile();
                          // Force rebuild by creating a new future
                          // (context as Element).markNeedsBuild();
                          setState(() {});

                        },
                        child: Text("Move Save File To Corrupted"),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () {
                          try
                          {
                          allUsersProvider.deleteUserData();
                          }
                          catch (e) {
                            print("Error deleting user data: $e");
                          }
                          // Force rebuild by creating a new future
                          setState(() {});

                          // (context as Element).markNeedsBuild();
                        },
                        child: Text("Delete Save File"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // //
        // // 3. SUCCESS
        // //
        // print("Snapshot has no error");
        // return MaterialApp(
        //   title: 'Navigation Demo',
        //   debugShowCheckedModeBanner: false,
        //   initialRoute: AppRoutes.role,
        //   routes: appRoutes,
        //   theme: ThemeData(
        //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //     useMaterial3: true,
        //   ),
        // );

        return Scaffold(
          body: Column(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      sessionProvider.isTeacher = false;
                      
                      if (allUsersProvider.allUserData.lastLoggedInUser is StudentUserData) {
                        print("Last logged in user recognized as a student");
                        Navigator.pushReplacementNamed(context, AppRoutes.wordList);
                      }
                      else {
                        print("Last logged in user not recognized as a student");
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
                      if (allUsersProvider.allUserData.lastLoggedInUser is TeacherUserData) {
                        // print("Last logged in user recognized as a student");
                        Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
                      }
                      else {
                        // print("Last logged in user not recognized as a teacher");
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
      },
    );



    
  }
}
