import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SyncState { synced, syncing, syncOff }

class ButtonSyncState extends StatelessWidget {
  final SyncState syncState;
  final Function onClickSync;

  const ButtonSyncState(
      {super.key, required this.syncState, required this.onClickSync});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (syncState == SyncState.synced) {
      icon = Icons.cloud_done_outlined;
    } else if (syncState == SyncState.syncOff) {
      icon = Icons.cloud_off;
    } else {
      icon = Icons.cloud_sync_outlined;
    }
    return IconButton(onPressed: () => onClickSync(), icon: Icon(icon));
  }
}
