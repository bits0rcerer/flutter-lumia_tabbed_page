import 'dart:math';

import 'package:lumia_tabbed_page/lumia_tabbed_page.dart';

void validateLumiaTabbedPageController(
    LumiaTabbedPageController c, int maxIndex) {
  c.selectedIndex = max(0, c.selectedIndex);
  c.selectedIndex = min(c.selectedIndex, maxIndex);
}
