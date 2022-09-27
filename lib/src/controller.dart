import 'package:flutter/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Controller to interact with a LumiaTabbedPage
class LumiaTabbedPageController extends ChangeNotifier {
  final _itemScrollController = ItemScrollController();

  ItemScrollController get itemScrollController => _itemScrollController;

  final _itemPositionListener = ItemPositionsListener.create();

  ItemPositionsListener get itemPositionListener => _itemPositionListener;

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
