import '../data/attempt_db.dart';
import './attempts_api.dart';

class AttemptSyncReport {
  final int pushed;
  final int pulled;
  final int conflicts;
  final int skipped;
  const AttemptSyncReport({
    required this.pushed,
    required this.pulled,
    required this.conflicts,
    required this.skipped,
  });
}

class AttemptSyncManager {
  final AttemptsDb db;
  AttemptSyncManager(this.db);

  Future<AttemptSyncReport> sync({required bool online}) async {
    if (!online) {
      return const AttemptSyncReport(
        pushed: 0,
        pulled: 0,
        conflicts: 0,
        skipped: 0,
      );
    }

    int pushed = 0, pulled = 0, conflicts = 0, skipped = 0;

    // 1) push dirty attempts
    final dirty = await db.dirtyAttempts();
    for (final a in dirty) {
      await AttemptsApi.upsert(a);
      pushed++;
    }
    await db.markAllClean(dirty.map((e) => e.uuid).toSet());

    // 2) pull remote attempts
    final remote = await AttemptsApi.listAll();
    final local = await db.getAll();
    final localMap = {for (final a in local) a.uuid: a};

    for (final r in remote) {
      final l = localMap[r.uuid];
      if (l == null) {
        await db.upsert(r.copyWith(dirty: false));
        pulled++;
      } else if (r.updatedAt.isAfter(l.updatedAt)) {
        await db.upsert(r.copyWith(dirty: false));
        conflicts++;
      } else {
        skipped++;
      }
    }

    return AttemptSyncReport(
      pushed: pushed,
      pulled: pulled,
      conflicts: conflicts,
      skipped: skipped,
    );
  }
}