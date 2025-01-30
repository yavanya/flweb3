import 'package:flutter/material.dart';
import 'package:flweb3/js_screen_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

/// The main screen of the application.
///
/// Displays an interface for loading and displaying images with controls for:
/// * Image URL input and loading
/// * Fullscreen mode toggle on double click image
/// * Overlay menu for additional options
///
/// The loaded image is centered on the screen and can be viewed in fullscreen mode.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Manages the state and behavior of the [HomePage].
class _HomePageState extends State<HomePage> {
  /// Controller for the image URL text input field
  final urlController = TextEditingController();

  /// Link for positioning the floating menu relative to its trigger button
  final buttonLayerLink = LayerLink();

  /// Entry for the overlay menu when displayed
  OverlayEntry? overlayEntry;

  /// Whether the overlay menu is currently displayed
  var isMenuOpen = false;

  @override
  void dispose() {
    urlController.dispose();
    hideMenu();
    super.dispose();
  }

  /// The floating action button that triggers the overlay menu.
  Widget get fab => FloatingActionButton(
        onPressed: showMenu,
        elevation: isMenuOpen ? 0 : 8,
        child: const Icon(Icons.add),
      );

  /// Displays or hides the overlay menu.
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
            followerAnchor: const Alignment(0.3, 1),
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

  /// Removes the overlay menu from view and resets the menu state.
  void hideMenu() {
    overlayEntry?.remove();
    overlayEntry = null;
    setState(() => isMenuOpen = false);
  }

  /// Validates and loads an image from the URL in [urlController].
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
                    decoration: const InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                ElevatedButton(
                  onPressed: loadImage,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
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
