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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        centerTitle: true, 
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  "WORD LIST",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              onPressed: () {
                allUsersProvider.clearLastUser();
                Navigator.pushReplacementNamed(context, AppRoutes.role);
              },
              child: const Text('Sign Out'),
            ),
          ],
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue[800],
                    ),
                  ),
                  Text(
                    fullName, // Use the safe variable
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.blue[900],

                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        height: 45,
                        child: Center(
                          child: Text(
                            "CURRENT WORD LIST: $currentWordListPath",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.blue[500],
                        height: 45,
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),

                        child: Center(
                          child: Text(
                            "NEXT WORD LIST: N/A",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),

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
                          child: Text(
                            "VIEW PROGRESS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),

              ],
            ),
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
                        final wordObject = sessionProvider.word_list.isEmpty
                            ? null
                            : sessionProvider.word_list[currWordInWordListIndex];
                  
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Word #${currWordInWordListIndex + 1}',
                                                    
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    'WORD GRADE: ${wordObject?.grade}',
                                    style: const TextStyle(fontSize: 22),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    wordObject?.text ?? 'N/A',
                                    style: const TextStyle(fontSize: 100),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, AppRoutes.practice);
                                      },
                                      child: const Text('Go Practice!'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // TODO: FUTURE SAMPLE SENTENCES DISPLAY
                  // SizedBox(width: 10,),
                  // Column(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         padding: const EdgeInsets.all(10),
                  //         decoration: BoxDecoration(
                  //           color: Colors.blue[300],
                  //         ),
                  //         // child: Column(
                  //         //   children: [
                  //         //     ListTile(
                  //         //       leading: Icon(Icons.person),
                  //         //       title: Text('John Doe'),
                  //         //       subtitle: Text('Software Engineer'),
                  //         //       trailing: Icon(Icons.arrow_forward),
                  //         //       onTap: () {
                  //         //         print('Tapped John Doe');
                  //         //       },
                  //         //     ),
                  //         //   ]
                  //         // ),
                  //         // child: ListView(
                  //         //   children: [
                  //         //     // ListTile(
                  //         //     //   leading: Icon(Icons.person),
                  //         //     //   title: Text('John Doe'),
                  //         //     //   subtitle: Text('Software Engineer'),
                  //         //     //   trailing: Icon(Icons.arrow_forward),
                  //         //     //   onTap: () {
                  //         //     //     print('Tapped John Doe');
                  //         //     //   },
                  //         //     // ),
                  //         //   ],
                  //         // ),
                  //       ),
                  //     ),
                  //   ],
                  // )


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
