import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/settings_action_listener.dart';
import 'package:tphotos/bloc/settings/data/settings.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsActionListener actionListener;
  final Settings settings;

  const SettingsScreen(
      {Key? key, required this.actionListener, required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Telegram username"),
              background: FlutterLogo(), // User's profile picture
            ),
          ),
          const SliverToBoxAdapter(
            child: Text("Rounded bottom corners container"),
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            ListTile(
              title: const Text("Delete After Save "),
              trailing: Switch(
                  value: settings.deleteAfterSave,
                  onChanged: (newValue) {
                    actionListener.updateDeleteAfterSave(newValue);
                  }),
            ),
            ListTile(
              title: const Text("Auto Sync"),
              trailing: Switch(
                  value: settings.autoSync,
                  onChanged: (newValue) {
                    actionListener.updateAutoSync(newValue);
                  }),
            ),
            ListTile(
              title: TextButton(
                  onPressed: actionListener.onSyncNowPressed,
                  child: const Text("Sync now")),
            ),
            ListTile(
              title: TextButton(
                  onPressed: actionListener.onFreeUpSpaceOnDevice,
                  child: const Text("Free up space on device")),
            ),
            ListTile(
              title:
                  Text('Folders in sync(${settings.selectedFolders.length})'),
              onTap: () {
                actionListener.onSelectFolders();
              },
            ),
            const Spacer(),
            ListTile(
              title: TextButton(
                  onPressed: actionListener.onTermsOfServicePressed,
                  child: const Text("Terms of use")),
            ),
            ListTile(
              title: TextButton(
                  onPressed: actionListener.onLegalNoticePressed,
                  child: const Text("Legal Notice")),
            ),
            const Spacer(
              flex: 2,
            ),
            Row(
              children: [
                OutlinedButton(
                    onPressed: () {
                      actionListener.onCloseSettingsPressed();
                    },
                    child: const Text("Logout")),
                TextButton(
                    onPressed: () {
                      actionListener.onDeleteAccount();
                    },
                    child: const Text("Delete Account"))
              ],
            )
          ]))
        ],
      ),
    ));
  }
}
