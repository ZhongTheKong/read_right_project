// In lib/screens/word_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/routes.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  @override
  Widget build(BuildContext context) {
    // Use `watch` to rebuild the UI when data changes.
    final allUsersProvider = context.watch<AllUsersProvider>();
    final sessionProvider = context.watch<SessionProvider>();

    // --- FIX 1: Safely access the username ---
    // Use a local variable with a null check to prevent crashing.
    final String username = allUsersProvider.allUserData.lastLoggedInUser?.username ?? 'Guest';

    // --- FIX 2: Safely access the current word ---
    // Check if the word list is empty before trying to access an element.
    final bool isWordListEmpty = sessionProvider.word_list.isEmpty;
    final wordObject = isWordListEmpty ? null : sessionProvider.word_list[sessionProvider.index];

    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Word List')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white, // Added for better visibility
                  ),
                ),
                Text(
                  username, // Use the safe variable
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Added for better visibility
                  ),
                ),
              ],
            ),

            // WORD DISPLAY
            SizedBox(
              width: 800,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                // --- FIX 3: Handle the case where the word list might be empty ---
                child: isWordListEmpty
                    ? const Center(
                  child: Text(
                    'Word list is loading or empty.\nPlease go to Practice first.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                )
                    : Column(
                  children: [
                    Text(
                      'Word #${sessionProvider.index + 1}',
                      style: const TextStyle(fontSize: 30),
                    ),
                    Text(
                      'This is the word you must practice\n'
                      // Access grade from the word object
                          'Current grade: ${wordObject?.grade}',
                      style: const TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      // Access text from the word object
                      wordObject?.text ?? 'N/A',
                      style: const TextStyle(fontSize: 100),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.practice);
                      },
                      child: const Text('Go Practice!'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                allUsersProvider.clearLastUser();
                Navigator.pushReplacementNamed(context, AppRoutes.role);
              },
              child: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
