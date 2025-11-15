import 'package:flutter/material.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:audio_session/audio_session.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
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
    final List<Map<String, dynamic>> pages = [
      {'title': 'Login', 'route': AppRoutes.login, 'icon': Icons.login},
      {'title': 'Practice', 'route': AppRoutes.practice, 'icon': Icons.school},
      {'title': 'Progress', 'route': AppRoutes.progress, 'icon': Icons.show_chart},
      {'title': 'Teacher Dashboard', 'route': AppRoutes.teacherDashboard, 'icon': Icons.dashboard},
      {'title': 'Word List', 'route': AppRoutes.wordList, 'icon': Icons.list},
      /// Removed from main page until bug is fixed
      {'title': 'Feedback', 'route': AppRoutes.feedback, 'icon': Icons.feedback},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Screen'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(page['icon'], color: Theme.of(context).primaryColor),
              title: Text(page['title']),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, page['route']);
              },
            ),
          );
        },
      ),

    );
  }
}
