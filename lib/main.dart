import 'package:flutter/material.dart';
import 'utils/routes.dart';
import 'package:audio_session/audio_session.dart';
import 'package:provider/provider.dart';
import 'providers/recording_provider.dart';

void main() {
  runApp(
    //const MaterialApp(home: MyApp())
     MultiProvider(
       providers: [
         ChangeNotifierProvider(create: (_) => RecordingProvider()),
         // ChangeNotifierProvider(create: (_) => NotesModel()),
         // You could add more models here later (e.g., UserModel, ThemeModel).
       ],
       child: const MaterialApp(home: MyApp())
     ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Navigation Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.main,
      routes: appRoutes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    // final List<Map<String, dynamic>> pages = [
    //   {'title': 'Login', 'route': AppRoutes.login, 'icon': Icons.login},
    //   {'title': 'Practice', 'route': AppRoutes.practice, 'icon': Icons.school},
    //   {'title': 'Progress', 'route': AppRoutes.progress, 'icon': Icons.show_chart},
    //   {'title': 'Teacher Dashboard', 'route': AppRoutes.teacherDashboard, 'icon': Icons.dashboard},
    //   {'title': 'Word List', 'route': AppRoutes.wordList, 'icon': Icons.list},
    //   /// Removed from main page until bug is fixed
    //   {'title': 'Feedback', 'route': AppRoutes.feedback, 'icon': Icons.feedback},
    // ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Main Menu'),
      //   centerTitle: true,
      // ),
      body: Row(
          children: [
            Expanded(

              
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school,
                        size: 60,
                      ),
                      Text(
                        "Student",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school,
                        size: 60,
                      ),
                      Text(
                        "Teacher",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),





      // body: ListView.builder(
      //   padding: const EdgeInsets.all(16),
      //   itemCount: pages.length,
      //   itemBuilder: (context, index) {
      //     final page = pages[index];
      //     return Card(
      //       elevation: 2,
      //       child: ListTile(
      //         leading: Icon(page['icon'], color: Theme.of(context).primaryColor),
      //         title: Text(page['title']),
      //         trailing: const Icon(Icons.arrow_forward_ios),
      //         onTap: () {
      //           Navigator.pushNamed(context, page['route']);
      //         },
      //       ),
      //     );
      //   },
      // ),

    );
  }
}
