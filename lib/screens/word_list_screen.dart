import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_right_project/providers/recording_provider.dart';
import 'package:read_right_project/utils/routes.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {

  @override
  Widget build(BuildContext context) {
    // Use context.watch<RecordingProvider>() to get the provider
    // This will make the widget rebuild whenever notifyListeners() is called.
    final recorder = context.watch<RecordingProvider>();

    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
              'Word List'
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // WORD DISPLAY
            SizedBox(
              width: 800,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  border: Border.all(color: Colors.blue, width: 2), // outline color & width
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      children: [
                        const SizedBox(height: 18), // size of word # font
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2), // outline color & width
                          ),
                          child: IconButton(
                            onPressed: () => context.read<RecordingProvider>().incrementIndex(-1),
                            icon: const Icon(
                                Icons.arrow_left
                            ),
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          'Word #${recorder.index + 1}',
                          style: const TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Select from the list below to practice',
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              // Use 'recorder' to get the current word.
                              recorder.word_list[recorder.index],
                              style: const TextStyle(fontSize: 100),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RecordingProvider>().
                            selectWord(recorder.word_list[recorder.index]);
                            Navigator.pushNamed(context, AppRoutes.practice);
                          },
                          child: const Text('Go Practice!'),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const SizedBox(height: 18),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2), // outline color & width
                          ),
                          child: IconButton(
                            // Use context.read() to call the function.
                            onPressed: () => context.read<RecordingProvider>().incrementIndex(1),
                            icon: const Icon(
                                Icons.arrow_right
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: const Text('Back to Main Screen'),
            )
          ],
        ),
      ),
    );
  }
}
