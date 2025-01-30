import 'dart:js_interop';
import 'package:flweb3/constants.dart';

/// JavaScript window object wrapper providing access to the global browser context
///
/// Provides typed access to the document object and other window-level APIs
extension type _Window(JSObject _) implements JSObject {
  external _Document get document;
}

/// JavaScript document object wrapper providing DOM manipulation capabilities
///
/// Enables interaction with the document's structure
extension type _Document(JSObject _) implements JSObject {
  external _Element get documentElement;
  external _Element? get fullscreenElement;
  external _Element? get webkitFullscreenElement;
  external void exitFullscreen();
  external _Element createElement(String tagName);
  external _Element? getElementById(String id);
  external _Element get body;
}

/// JavaScript DOM element wrapper providing element-specific functionality
extension type _Element(JSObject _) implements JSObject {
  external void requestFullscreen();
  external set src(String value);
  external set style(String value);
  external set id(String value);
  external void addEventListener(String type, JSFunction callback);
  external void appendChild(_Element child);
  external void remove();
}

/// Gets the global window object.
_Window get _window => globalContext as _Window;

/// Gets the document object from the window.
_Document get _document => _window.document;

/// Gets the document's root element.
_Element get _element => _window.document.documentElement;

bool get _isFullscreenJS =>
    _document.fullscreenElement != null ||
    _document.webkitFullscreenElement != null;

/// Requests the document to enter fullscreen mode.
///
/// This operation may fail if:
/// * Not triggered by a user interaction
/// * Fullscreen mode is not supported
/// * The browser denies the request
void requestFullscreenJS() {
  if (!_isFullscreenJS) {
    try {
      _element.requestFullscreen();
    } catch (_) {
      // TODO: Currently failing silently, but could add user alerts or error handling based on requirements
      // Common rejection reason: not triggered by user interaction
    }
  }
}

/// Exits fullscreen mode if the document is currently fullscreen.
void exitFullscreenJS() {
  if (_isFullscreenJS) {
    try {
      _document.exitFullscreen();
    } catch (_) {
      // TODO: Currently failing silently, but could add user alerts or error handling based on requirements
    }
  }
}

/// Toggles between fullscreen and normal screen modes.
void toggleFullscreenJS() {
  _isFullscreenJS ? exitFullscreenJS() : requestFullscreenJS();
}

/// Adds or updates the center image element in the document.
///
/// Parameters:
/// * [url] - The image URL to display
/// * [style] - CSS style string, defaults to [kCenterImageStyle]
///
/// Features:
/// * Centers the image on screen using CSS positioning
/// * Supports fullscreen toggle on double click
/// * Replaces any existing center image
/// * Handles DOM manipulation errors silently
///
/// Example:
/// ```dart
/// addCenterImageJS('https://example.com/image.jpg');
/// ```
void addCenterImageJS(String url, [String style = kCenterImageStyle]) {
  try {
    // Clean up existing image if any
    final existingImg = _document.getElementById('center-image');
    existingImg?.remove();

    // Create and configure new image
    final img = _document.createElement('img')
      ..id = 'center-image'
      ..style = style
      ..src = url
      ..addEventListener('dblclick', toggleFullscreenJS.toJS);

    _document.body.appendChild(img);
  } catch (_) {
    // TODO: Currently failing silently, but could add user alerts or error handling based on requirements
  }
}
