import 'package:flutter/material.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:audio_session/audio_session.dart';


// -------------------------------------------------------------
// DeveloperScreen
//
// A simple developer/testing utility screen that shows links to
// different pages in the app. Useful for navigating while debugging.
//
// PRE: AppRoutes must be configured in MaterialApp routes.
// POST: Renders a list of tappable cards that navigate to screens.
// -------------------------------------------------------------
class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}


// -------------------------------------------------------------------------
// _DeveloperScreenState
//
// Handles:
//   • Initializing audio session for speech playback
//   • Building a list of shortcut navigation tiles
// -------------------------------------------------------------------------
class _DeveloperScreenState extends State<DeveloperScreen> {

  // ---------------------------------------------------------------------
  // PRE: Called inside initState()
  //
  // Configures the app’s audio session so audio playback and recording
  // behave properly when navigating through developer/test screens.
  //
  // POST: AudioSession is configured using speech mode.
  // ---------------------------------------------------------------------
  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }
  
  // ---------------------------------------------------------------------
  // PRE: Widget is first inserted into the widget tree.
  //
  // Initializes audio session immediately when the screen loads.
  //
  // POST: Audio session is ready for use by recording or playback features.
  // ---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _configureAudioSession();
  }

  // ---------------------------------------------------------------------
  // PRE: Providers and Navigator must be available above this widget.
  //
  // Builds the developer menu UI:
  //   • A list of app pages (Login, Practice, Dashboard, etc.)
  //   • Each card navigates to its designated route when tapped
  //
  // POST: Returns a Scaffold with a scrollable list of navigation options.
  // ---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    // -----------------------------------------------------------------
    // Setup list of pages to show on the developer navigation screen.
    //
    // Each page entry includes:
    //   • Display title
    //   • Route name
    //   • Icon representing the page
    //
    // POST: Used to dynamically generate navigation tiles.
    // -----------------------------------------------------------------
    final List<Map<String, dynamic>> pages = [
      {'title': 'Login', 'route': AppRoutes.login, 'icon': Icons.login},
      {'title': 'Practice', 'route': AppRoutes.practice, 'icon': Icons.school},
      {'title': 'Progress', 'route': AppRoutes.progress, 'icon': Icons.show_chart},
      {'title': 'Teacher Dashboard', 'route': AppRoutes.teacherDashboard, 'icon': Icons.dashboard},
      {'title': 'Word List', 'route': AppRoutes.wordList, 'icon': Icons.list},

      /// Removed from main navigation until bug is fixed
      {'title': 'Feedback', 'route': AppRoutes.feedback, 'icon': Icons.feedback},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Screen'),
        centerTitle: true,
      ),

      // -----------------------------------------------------------------
      // PRE: pages list must be populated.
      //
      // Builds a scrollable list of Cards representing screen options.
      // Tapping a card pushes the associated route.
      //
      // POST: User can jump to various screens quickly for testing.
      // -----------------------------------------------------------------
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];

          return Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(
                page['icon'],
                color: Theme.of(context).primaryColor,
              ),
              title: Text(page['title']),
              trailing: const Icon(Icons.arrow_forward_ios),

              // Navigation action
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
