import 'dart:async';
import '../models/attempt.dart';

class AttemptsApi {
  static final Map<String, Attempt> _remote = {};

  static const Duration latency = Duration(milliseconds: 600);

  static Future<List<Attempt>> listAll() async {
    await Future.delayed(latency);
    return _remote.values.toList();
  }

  static Future<void> upsert(Attempt a) async {
    await Future.delayed(latency);
    _remote[a.uuid] = a;
  }

  static Future<void> delete(String uuid) async {
    await Future.delayed(latency);
    _remote.remove(uuid);
  }
}
