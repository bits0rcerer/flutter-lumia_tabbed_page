import 'package:flutter/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../lumia_tabbed_page.dart';
import 'common.dart';

class LumiaTabbedPageHeader extends StatefulWidget {
  const LumiaTabbedPageHeader({
    super.key,

    /// Titles for the pages
    required this.pageTitles,

    /// Padding around the header
    this.headerPadding = const EdgeInsets.symmetric(vertical: 4.0),

    /// Duration of transitions invoked by code
    this.scrollDuration = const Duration(milliseconds: 250),
    this.controller,
    this.selectedHeaderTextStyle,
    this.unselectedHeaderTextStyle,
    this.initialIndex = 0,
  });

  final LumiaTabbedPageController? controller;
  final Iterable<String> pageTitles;
  final EdgeInsets headerPadding;
  final int initialIndex;
  final Duration scrollDuration;
  final TextStyle? unselectedHeaderTextStyle;
  final TextStyle? selectedHeaderTextStyle;

  @override
  State<LumiaTabbedPageHeader> createState() => _LumiaTabbedPageHeaderState();
}

class _LumiaTabbedPageHeaderState extends State<LumiaTabbedPageHeader> {
  late LumiaTabbedPageController controller;
  late PageController pageController;

  @override
  void initState() {
    controller = widget.controller ??
        LumiaTabbedPageController(
          initialIndex: widget.initialIndex,
        );
    _validateController(controller);

    pageController =
        PageController(initialPage: controller.selectedIndex, keepPage: true);

    controller.addListener(_controllerListener);
    super.initState();
  }

  void _controllerListener() {
    _validateController(controller);

    setState(() {});
    controller.itemScrollController.scrollTo(
      index: controller.selectedIndex,
      duration: widget.scrollDuration,
    );
  }

  void _validateController(LumiaTabbedPageController c) =>
      validateLumiaTabbedPageController(c, widget.pageTitles.length - 1);

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.pageTitles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => setState(() => controller.selectedIndex = index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.pageTitles.elementAt(index),
              maxLines: 1,
              style: _getTextStyle(index),
            ),
          ),
        );
      },
      initialScrollIndex: controller.initialIndex,
      physics: const ClampingScrollPhysics(),
      padding: widget.headerPadding,
      scrollDirection: Axis.horizontal,
      itemScrollController: controller.itemScrollController,
      itemPositionsListener: controller.itemPositionListener,
    );
  }

  TextStyle _getTextStyle(int index) {
    final selected = index == controller.selectedIndex;

    final customStyle = selected
        ? widget.selectedHeaderTextStyle
        : widget.unselectedHeaderTextStyle;

    return customStyle ??
        (selected
            ? const TextStyle(
                inherit: true, fontSize: 40, fontWeight: FontWeight.w900)
            : const TextStyle(
                inherit: true, fontSize: 40, fontWeight: FontWeight.w400));
  }
}
