class AppData {
  AppData._internal();
  static final AppData _appData = AppData._internal();

  bool isPro = false;

  factory AppData() {
    return _appData;
  }
}

final appData = AppData();
