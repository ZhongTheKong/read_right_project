import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/attempt.dart';
import '../data/attempt_db.dart';
import '../services/attempts_sync_manager.dart';

class TeacherDashboardTestScreen extends StatefulWidget {
  const TeacherDashboardTestScreen({super.key});

  @override
  State<TeacherDashboardTestScreen> createState() =>
      _TeacherDashboardTestScreenState();
}

class _TeacherDashboardTestScreenState
    extends State<TeacherDashboardTestScreen> {
  final AttemptsDb db = AttemptsDb();
  late final SyncManager syncManager;
  List<Attempt> localAttempts = [];

  @override
  void initState() {
    super.initState();
    syncManager = SyncManager(db);
    _loadAttempts();
  }

  Future<void> _loadAttempts() async {
    final attempts = await db.getAll();
    setState(() => localAttempts = attempts);
  }

  Future<void> _addDummyAttempt() async {
    final attempt = Attempt.newAttempt(
      studentId: 'student123',
      classId: 'class456',
      audioUrl: 'dummy_audio.mp3',
      transcript: 'Test transcript ${DateTime.now()}',
    );

    print("There is an errorrr!!!!");
    await db.upsert(attempt);
    await _loadAttempts();
  }

  Future<void> _sync() async {
    final report = await syncManager.sync(online: true);
    print('Sync report: $report');
    await _loadAttempts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addDummyAttempt,
              child: const Text('Add Dummy Attempt'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sync,
              child: const Text('Sync Attempts'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: localAttempts.length,
                itemBuilder: (context, index) {
                  final a = localAttempts[index];
                  return ListTile(
                    title: Text('Transcript: ${a.transcript}'),
                    subtitle: Text(
                        'Dirty: ${a.dirty} | Updated: ${a.updatedAt.toIso8601String()}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
