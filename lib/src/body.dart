import 'package:flutter/material.dart';
import 'package:lumia_tabbed_page/src/common.dart';

import '../lumia_tabbed_page.dart';

class LumiaTabbedPageBody extends StatefulWidget {
  const LumiaTabbedPageBody({
    super.key,

    /// IndexedWidgetBuilder for the pages
    required this.bodyBuilder,

    /// Number of pages
    required this.pageCount,

    /// Duration of transitions invoked by code
    this.scrollDuration = const Duration(milliseconds: 250),
    this.controller,
    this.initialIndex = 0,
  });

  final LumiaTabbedPageController? controller;
  final int initialIndex;

  final IndexedWidgetBuilder bodyBuilder;
  final int pageCount;
  final Duration scrollDuration;

  @override
  State<LumiaTabbedPageBody> createState() => _LumiaTabbedPageBodyState();
}

class _LumiaTabbedPageBodyState extends State<LumiaTabbedPageBody> {
  late LumiaTabbedPageController controller;
  late PageController pageController;
  bool _isScrolling = false;

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

    _isScrolling = true;
    controller.removeListener(_controllerListener);
    pageController
        .animateToPage(
      controller.selectedIndex,
      duration: widget.scrollDuration,
      curve: Curves.easeInOutCubic,
    )
        .then((_) {
      controller.addListener(_controllerListener);
      _isScrolling = false;
    });
  }

  void _validateController(LumiaTabbedPageController c) =>
      validateLumiaTabbedPageController(c, widget.pageCount - 1);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: widget.bodyBuilder,
      itemCount: widget.pageCount,
      controller: pageController,
      onPageChanged: (index) {
        if (!_isScrolling) {
          setState(() => controller.selectedIndex = index);
        }
      },
    );
  }
}
