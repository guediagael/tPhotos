abstract mixin class SettingsActionListener{
  void updateDeleteAfterSave(bool newValue);
  void updateAutoSync(bool newValue);
  void onSyncNowPressed();
  void onSelectFolders();
  void onFreeUpSpaceOnDevice();
  void onTermsOfServicePressed();
  void onLegalNoticePressed();
  void onLogoutPressed();
  void onDeleteAccount();
}