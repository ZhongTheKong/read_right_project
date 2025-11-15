import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/utils/routes.dart';
import '../providers/session_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {


  @override
  Widget build(BuildContext context) {

    // SessionProvider sessionProvider = context.watch<RecordingProvider>();


    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, child) {


        return Scaffold(
          appBar: AppBar(title: const Text('Progress Screen')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'This is the Progress Screen. Here, you can see how well you are doing with your practice',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                SizedBox(
                    height: 100,
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the user's data from the provider
                        Text(
                            'Username: ${sessionProvider.currentUser}',
                            style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                            'Number of Attempts: ${sessionProvider.numberOfAttempts}',
                            style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                            'Average Score: ${sessionProvider.averageScore.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 20),

                Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Consumer<SessionProvider>(
                    builder: (BuildContext context, SessionProvider recorder, Widget? child) => recorder.attempts.isEmpty
                      ? const Center(
                          child: Text('No attempts yet')
                      )
                      : ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(8),
                        child: ListView.separated(
                            itemCount: recorder.attempts.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                            
                              final iterAttempt = recorder.attempts[i];
                              final exists = File(iterAttempt.filePath).existsSync();
                            
                              return Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(width: 1),
                                  ),
                                  title: Text(iterAttempt.word),
                                                            
                                  subtitle: Text(
                                      'Attempt ${recorder.attempts.length - i}\nDate: ${iterAttempt.createdAt.toLocal()}\nDuration: ~${(iterAttempt.durationMs / 1000).toStringAsFixed(1)}s'),
                                                            
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min, 
                                    children: [
                                      IconButton(
                                        tooltip: 'Play',
                                        onPressed: (!exists || recorder.isPlaying)
                                            ? null
                                            : () => recorder.play(iterAttempt.filePath),
                                        icon: const Icon(Icons.play_arrow),
                                      ),
                                      
                                      IconButton(
                                        tooltip: 'Stop',
                                                            
                                        // TODO: CREATE A BETTER PLAY ATTEMPT BUTTON CALLBACK
                                        onPressed: recorder.isPlaying
                                            ? () => recorder.player.stop().then(
                                                (_) => setState(() => recorder.isPlaying = false))
                                            : null,
                                                            
                                        icon: const Icon(Icons.stop),
                                      ),
                                                        
                                      IconButton(
                                        onPressed: () {
                                          recorder.selectedIndex = i;
                                          Navigator.pushNamed(context, AppRoutes.feedback);
                                        }, 
                                        icon: Icon(Icons.feedback)
                                      )
                                    ]
                                  ),
                                ),
                              );
                            
                              
                            },
                          ),
                      ),
                  ),
                ),
              ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/practice');
                  },
                  child: const Text('Practice'),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    // Navigate back to main screen and clear previous routes
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  child: const Text('Back to Main Screen'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );


      },
    );


  }
}