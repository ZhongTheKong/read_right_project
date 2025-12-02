// In lib/screens/word_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/all_users_provider.dart';
import 'package:read_right_project/providers/session_provider.dart';
import 'package:read_right_project/utils/routes.dart';
import 'package:read_right_project/utils/student_user_data.dart';
import 'package:read_right_project/utils/word_list_progression_data.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  // This Future will hold the loading operation and ensure it only runs once per screen visit.
  Future<void>? _loadWordsFuture;

  String currentWordListPath = "seed_words.csv";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We initialize the future here to ensure it's called only once.
    // It has access to the provider context and runs before the first build.
    if (_loadWordsFuture == null) {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      // If the list is already loaded, complete immediately. Otherwise, load it.
      if (sessionProvider.word_list.isEmpty) {
        _loadWordsFuture = sessionProvider.loadWordList('assets/$currentWordListPath');
      } else {
        _loadWordsFuture = Future.value(); // Already loaded, create a completed future.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use `watch` to rebuild the UI when provider data changes.
    final allUsersProvider = context.watch<AllUsersProvider>();
    final sessionProvider = context.watch<SessionProvider>();

    // Safely access the username with a null check.
    // This should only be getting hit if going to word list from dev mode
    String fullName = 'Guest';
    if (allUsersProvider.allUserData.lastLoggedInUser != null)
    {
      fullName = "${allUsersProvider.allUserData.lastLoggedInUser!.firstName} ${allUsersProvider.allUserData.lastLoggedInUser!.lastName}";
    }
    // final String username = allUsersProvider.allUserData.lastLoggedInUser?.username ?? 'Guest';

    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(centerTitle: true, title: const Text('Word List')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    fullName, // Use the safe variable
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      "CURRENT WORD LIST: $currentWordListPath",
                      style: TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                          )
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.progress);
                        }, 
                        child: Text("PROGRESS")
                      ),
                    ),
                  ],
                )
              ],
            ),

            // --- FIX: WRAP THE WORD DISPLAY IN A FUTUREBUILDER ---
            // SizedBox(
            //   width: 800,
            //   height: 350, // Give it a fixed height to prevent layout jumps
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FutureBuilder<void>(
                      future: _loadWordsFuture,
                      builder: (context, snapshot) {
                        // While the future is waiting, show a loading spinner.
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }
                  
                        // If an error occurred during loading, display an error message.
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Error: Failed to load words.',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          );
                        }
                  
                        int currWordInWordListIndex = allUsersProvider.getWordListCurrIndex(sessionProvider.word_list_name);
                  
                        // Once the data is loaded, build the main UI.
                        // final wordObject = sessionProvider.word_list.isEmpty
                        //     ? null
                        //     : sessionProvider.word_list[sessionProvider.index];
                        final wordObject = sessionProvider.word_list.isEmpty
                            ? null
                            : sessionProvider.word_list[currWordInWordListIndex];
                  
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            // border: Border.all(color: Colors.blue, width: 2),
                            // borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // 'Word #${sessionProvider.index + 1}',
                                'Word #${currWordInWordListIndex + 1}',
                  
                                style: const TextStyle(fontSize: 30),
                              ),
                              Text(
                                'WORD GRADE: ${wordObject?.grade}',
                                style: const TextStyle(fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () {
                allUsersProvider.clearLastUser();
                Navigator.pushReplacementNamed(context, AppRoutes.role);
              },
              child: const Text('Sign Out'),
            ),

            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}
