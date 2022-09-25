A tabbed page widget for flutter inspired by the lumia ui on Windows phones.

## Features

![Example](example.gif)

## Usage

```dart
final controller = LumiaTabbedPageController(initialIndex: 3);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Center(
      child: LumiaTabbedPage(
          controller: controller,
          pageTitles: List.generate(10, (index) => 'Page$index'),
          bodyBuilder: (BuildContext context, int index) {
            return Center(child: Text('Page #$index'));
          }),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: controller.forward,
      child: const Icon(Icons.play_arrow),
    ),
  );
}
```

## Additional information

Feel free to suggest improvements on my [GitHub Repo](https://github.com/bits0rcerer/flutter-lumia_tabbed_page).
