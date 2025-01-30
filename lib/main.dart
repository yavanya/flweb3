import 'package:flutter/material.dart';
import 'package:flweb3/js_screen_utils.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final urlController = TextEditingController();
  final buttonLayerLink = LayerLink();
  OverlayEntry? overlayEntry;
  var isMenuOpen = false;

  @override
  void dispose() {
    urlController.dispose();
    hideMenu();
    super.dispose();
  }

  Widget get fab => FloatingActionButton(
        onPressed: showMenu,
        elevation: isMenuOpen ? 0 : 8,
        child: Icon(Icons.add),
      );

  void showMenu() {
    if (isMenuOpen) {
      hideMenu();
      return;
    }

    setState(() => isMenuOpen = true);

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: hideMenu,
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          CompositedTransformFollower(
            link: buttonLayerLink,
            followerAnchor: Alignment(0.3, 1),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 160,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Enter fullscreen'),
                        onTap: () {
                          hideMenu();
                          requestFullscreenJS();
                        },
                      ),
                      ListTile(
                        title: const Text('Exit fullscreen'),
                        onTap: () {
                          hideMenu();
                          exitFullscreenJS();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CompositedTransformFollower(
            link: buttonLayerLink,
            targetAnchor: Alignment.center,
            followerAnchor: Alignment.center,
            child: fab,
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void hideMenu() {
    overlayEntry?.remove();
    overlayEntry = null;
    setState(() => isMenuOpen = false);
  }

  void loadImage() {
    final url = urlController.text.trim();
    if (url.isNotEmpty && Uri.tryParse(url) != null) {
      addCenterImageJS(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                ElevatedButton(
                  onPressed: loadImage,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: CompositedTransformTarget(
        link: buttonLayerLink,
        child: fab,
      ),
    );
  }
}
