import 'package:flutter/widgets.dart';

/// Controller to interact with a LumiaTabbedPage
class LumiaTabbedPageController extends ChangeNotifier {
  /// initial tabbed select by the LumiaTabbedPage
  final int initialIndex;
  int _selectedIndex = 0;

  /// get the current selected page index
  int get selectedIndex => _selectedIndex;

  /// set the current selected page index
  set selectedIndex(int newIndex) {
    if (newIndex == _selectedIndex) return;
    _selectedIndex = newIndex;
    notifyListeners();
  }

  LumiaTabbedPageController({this.initialIndex = 0}) {
    _selectedIndex = initialIndex;
  }

  /// display the next page
  next() {
    selectedIndex++;
  }

  /// display the previous page
  previous() {
    selectedIndex++;
  }
}
