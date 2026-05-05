import 'dart:async';
import 'package:khidma/core/database/local_database.dart';

class BackgroundSyncService {
  static const String _pendingActionsKey = 'pending_sync_actions';

  static Future<void> addPendingAction(Map<String, dynamic> action) async {
    List<dynamic> currentActions = LocalDatabase.getData(_pendingActionsKey) ?? [];
    currentActions.add(action);
    await LocalDatabase.saveData(_pendingActionsKey, currentActions);
  }

  static Future<void> syncPendingActions(Future<bool> Function(Map<String, dynamic>) performAction) async {
    List<dynamic> currentActions = LocalDatabase.getData(_pendingActionsKey) ?? [];
    if (currentActions.isEmpty) return;

    List<dynamic> failedActions = [];

    for (var action in currentActions) {
      bool success = await performAction(Map<String, dynamic>.from(action));
      if (!success) {
        failedActions.add(action);
      }
    }

    await LocalDatabase.saveData(_pendingActionsKey, failedActions);
  }
}
