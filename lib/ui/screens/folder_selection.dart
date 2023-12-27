import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:tphotos/action_listeners/folder_selection_listener.dart';

class FolderSelectionScreen extends StatefulWidget {
  final List<String> selectedFolders;
  final FolderSelectionListener listener;
  final bool shouldShowModelOnOpen;

  const FolderSelectionScreen(
      {required this.selectedFolders,
      required this.listener,
      required this.shouldShowModelOnOpen,
      super.key});

  @override
  State<StatefulWidget> createState() => _FolderSelectionScreenState();
}

class _FolderSelectionScreenState extends State<FolderSelectionScreen> {
  @override
  void didChangeDependencies() {
    if (widget.shouldShowModelOnOpen) showFolderSelection(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: const Text("Synchronized Folders"),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () => showFolderSelection(context),
          child: const Icon(Icons.add),
        ),
        ElevatedButton(
            onPressed: () => widget.listener
                .onFolderSelectionClose(true, widget.selectedFolders),
            child: const Text("Save and close"))
      ],
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.selectedFolders.length,
                shrinkWrap: true,
                itemBuilder: (ctx, idx) {
                  return ListTile(
                    title: Text(widget.selectedFolders[idx]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => widget.listener
                          .onFolderUnselected(idx, widget.selectedFolders),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void showFolderSelection(BuildContext context) async {
    var rootDirs = await ExternalPath.getExternalStorageDirectories();
    List<FilesystemPickerShortcut> shortcuts = [];
    for (var element in rootDirs) {
      shortcuts.add(
          FilesystemPickerShortcut(name: element, path: Directory(element)));
    }

    FilesystemPicker.openDialog(
      context: context,
      fsType: FilesystemType.folder,
      shortcuts: shortcuts,
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        debugPrint(
            "folder_selection::showFolderSelection:: folder selected $value");
        widget.listener.onFolderSelected(value, widget.selectedFolders);
      }
    });
  }
}
