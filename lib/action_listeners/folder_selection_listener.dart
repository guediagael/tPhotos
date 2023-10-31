abstract mixin class FolderSelectionListener{
  void onFolderSelected(String folder,List<String> selectedFolders);
  void onFolderUnselected(int folderIndex,List<String> selectedFolders);
  void onFolderSelectionClose(bool save, List<String> selectedFolders);
}