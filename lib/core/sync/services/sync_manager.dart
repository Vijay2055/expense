import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'sync_service.dart';

class SyncManager {
  final SyncService syncService;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _started = false;

  SyncManager({
    required this.syncService,
    required this.connectivity,
  });

  void start() {
    if (_started) {
      return;
    }

    _started = true;

    // Check current connection when app starts.
    _syncIfConnected();

    // Listen for connectivity changes.
    _subscription = connectivity.onConnectivityChanged.listen(
      (results) {
        _syncIfConnected(results);
      },
    );
  }

  Future<void> _syncIfConnected([
    List<ConnectivityResult>? results,
  ]) async {
    final connection = results ??
        await connectivity.checkConnectivity();

    final hasConnection = connection.any(
      (result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );

    if (!hasConnection) {
      return;
    }

    await syncService.sync();
  }

  Future<void> syncNow() async {
    await syncService.sync();
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _started = false;
  }

  Future<void> dispose() async {
    await stop();
  }
}