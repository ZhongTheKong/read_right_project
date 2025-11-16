import 'dart:async';
import '../models/attempt.dart';

/// Mock remote API for demo purposes.
/// In a real app, replace with HTTP/REST or Firestore calls.
class RemoteApi {
  // In-memory “server storage”
  static final Map<String, Attempt> _remoteStore = {};

  // Add a little latency so students see "sync" doing work
  static const Duration latency = Duration(milliseconds: 600);

  /// Return all remote notes
  static Future<List<Attempt>> listAll() async {
    await Future.delayed(latency);
    return _remoteStore.values.toList();
  }

  /// Create or update a remote note (keyed by uuid)
  static Future<void> upsert(Attempt n) async {
    await Future.delayed(latency);
    _remoteStore[n.uuid] = n;
  }

  /// Delete a note remotely
  static Future<void> delete(String uuid) async {
    await Future.delayed(latency);
    _remoteStore.remove(uuid);
  }
}
