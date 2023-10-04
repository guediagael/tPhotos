import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/main_action_listener.dart';
import 'package:tphotos/dispatchers/timeline_dispatcher.dart';
import 'package:tphotos/ui/widgets/bottom_app_bar.dart';

import 'search_screen.dart';
import 'timeline_screen.dart';

class MainScreen extends StatefulWidget {
  final MainActionListener mainActionListener;

  const MainScreen({Key? key, required this.mainActionListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentScreen;

  @override
  void initState() {
    currentScreen = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: widget.mainActionListener.settingsSelected,
              icon: const Icon(Icons.settings))
        ],
      ),
      body: IndexedStack(
        index: currentScreen,
        children: [TimelineDispatcher.buildTimelineScreen(), SearchScreen()],
      ),
      bottomNavigationBar: TphotosBottomAppBar(
          currentIndex: currentScreen,
          onTap: (index) {
            setState(() {
              currentScreen = index;
            });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.mainActionListener.addPictureSourceSelected,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ));
  }
}
