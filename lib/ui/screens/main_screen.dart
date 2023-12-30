import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/main_action_listener.dart';
import 'package:tphotos/dispatchers/timeline_dispatcher.dart';
import 'package:tphotos/ui/widgets/bottom_app_bar.dart';

import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  final MainActionListener mainActionListener;
  final bool shouldShowFab;
  final String timelineKeyValue;

  const MainScreen(
      {super.key,
      required this.mainActionListener,
      this.shouldShowFab = false,
      required this.timelineKeyValue});

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
        children: [
          TimelineDispatcher.buildTimelineScreen(
              key: Key("TimelineDispatcher ${widget.timelineKeyValue}")),
          const SearchScreen()
        ],
      ),
      bottomNavigationBar: TphotosBottomAppBar(
          currentIndex: currentScreen,
          onTap: (index) {
            setState(() {
              currentScreen = index;
            });
          }),
      floatingActionButton: widget.shouldShowFab
          ? FloatingActionButton(
              onPressed: widget.mainActionListener.addMediaSourceSelected,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    ));
  }
}
