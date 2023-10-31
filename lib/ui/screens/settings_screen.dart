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
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28)),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            ListTile(
              title:
                  Text('Folders in sync(${settings.selectedFolders.length})'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: actionListener.onSelectFolders,
              ),
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
                title: const Text("Sync now"),
                trailing: IconButton(
                  icon: const Icon(Icons.cloud_sync),
                  onPressed: actionListener.onSyncNowPressed,
                )),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    actionListener.onLogoutPressed();
                  },
                  child: const Text("Logout")),
            ),
            TextButton(
                onPressed: () {
                  actionListener.onDeleteAccount();
                },
                child: const Text("Delete Account"))
          ]))
        ],
      ),
    ));
  }
}
