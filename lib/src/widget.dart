import 'package:flutter/material.dart';
import 'package:lumia_tabbed_page/src/body.dart';
import 'package:lumia_tabbed_page/src/controller.dart';
import 'package:lumia_tabbed_page/src/header.dart';

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
  State<LumiaTabbedPage> createState() => _LumiaTabbedPageState();
}

class _LumiaTabbedPageState extends State<LumiaTabbedPage> {
  late LumiaTabbedPageController controller;
  late PageController pageController;

  @override
  void initState() {
    controller = widget.controller ??
        LumiaTabbedPageController(
          initialIndex: widget.initialIndex,
        );

    pageController =
        PageController(initialPage: controller.selectedIndex, keepPage: true);

    super.initState();
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
            flexibleSpace: SizedBox(
                width: mq.size.width,
                child: LumiaTabbedPageHeader(
                  controller: controller,
                  pageTitles: widget.pageTitles,
                  headerPadding: widget.headerPadding,
                  initialIndex: widget.initialIndex,
                  selectedHeaderTextStyle: widget.selectedHeaderTextStyle,
                  unselectedHeaderTextStyle: widget.unselectedHeaderTextStyle,
                )),
            centerTitle: true,
          ),
          body: LumiaTabbedPageBody(
            bodyBuilder: widget.bodyBuilder,
            pageCount: widget.pageTitles.length,
            initialIndex: widget.initialIndex,
            controller: controller,
            scrollDuration: widget.scrollDuration,
          ),
        ));
  }
}
