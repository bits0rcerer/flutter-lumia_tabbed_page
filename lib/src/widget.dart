import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lumia_tabbed_page/src/controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LumiaTabbedPage extends StatefulWidget {
  const LumiaTabbedPage({
    super.key,

    /// IndexedWidgetBuilder for the pages
    required this.bodyBuilder,

    /// Titles for the pages
    required this.pageTitles,

    /// Padding around the header
    this.headerPadding = const EdgeInsets.symmetric(vertical: 4.0),

    /// Duration of transitions invoked by code
    this.scrollDuration = const Duration(milliseconds: 250),
    this.controller,
    this.initialIndex = 0,
    this.selectedHeaderTextStyle,
    this.unselectedHeaderTextStyle,
    this.backgroundColor,
  });

  final LumiaTabbedPageController? controller;
  final int initialIndex;

  final IndexedWidgetBuilder bodyBuilder;
  final Iterable<String> pageTitles;
  final EdgeInsets headerPadding;

  final Color? backgroundColor;
  final Duration scrollDuration;
  final TextStyle? unselectedHeaderTextStyle;
  final TextStyle? selectedHeaderTextStyle;

  @override
  _LumiaTabbedPageState createState() => _LumiaTabbedPageState();
}

class _LumiaTabbedPageState extends State<LumiaTabbedPage> {
  final itemScrollController = ItemScrollController();
  final itemPositionListener = ItemPositionsListener.create();

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
    _scrollToPage(controller.selectedIndex, scrollHeader: false);
  }

  void _validateController(LumiaTabbedPageController c) {
    controller.selectedIndex = max(0, controller.selectedIndex);
    controller.selectedIndex =
        min(controller.selectedIndex, widget.pageTitles.length - 1);
  }

  Future<void> _scrollToPage(int index,
      {bool scrollHeader = true, bool scrollBody = true}) async {
    if (scrollHeader) {
      await itemScrollController.scrollTo(
          index: index,
          duration: widget.scrollDuration,
          curve: Curves.easeInOutCubic);
      setState(() {
        controller.selectedIndex = index;
      });
    }
    if (scrollBody) {
      await pageController.animateToPage(
        index,
        duration: widget.scrollDuration,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SizedBox(
        height: mq.size.height,
        child: Scaffold(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            primary: false,
            flexibleSpace:
                SizedBox(width: mq.size.width, child: _buildHeader()),
            centerTitle: true,
          ),
          body: _buildBody(),
        ));
  }

  Widget _buildHeader() {
    return ScrollablePositionedList.builder(
      itemCount: widget.pageTitles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.removeListener(_controllerListener);
            _scrollToPage(index, scrollHeader: false).then((_) {
              controller.addListener(_controllerListener);
            });
          },
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
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionListener,
    );
  }

  Widget _buildBody() {
    return PageView.builder(
      itemBuilder: widget.bodyBuilder,
      itemCount: widget.pageTitles.length,
      controller: pageController,
      onPageChanged: (index) => _scrollToPage(index, scrollBody: false),
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
