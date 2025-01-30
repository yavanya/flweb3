import 'dart:js_interop';

import 'package:flweb3/constants.dart';

extension type _Window(JSObject _) implements JSObject {
  external _Document get document;
}

extension type _Document(JSObject _) implements JSObject {
  external _Element get documentElement;
  external _Element? get fullscreenElement;
  external _Element? get webkitFullscreenElement;
  external void exitFullscreen();
  external _Element createElement(String tagName);
  external _Element? getElementById(String id);
  external _Element get body;
}

extension type _Element(JSObject _) implements JSObject {
  external void requestFullscreen();
  external set src(String value);
  external set style(String value);
  external set id(String value);
  external void addEventListener(String type, JSFunction callback);
  external void appendChild(_Element child);
  external void remove();
}

_Window get _window => globalContext as _Window;
_Document get _document => _window.document;
_Element get _element => _window.document.documentElement;

bool get _isFullscreenJS =>
    _document.fullscreenElement != null ||
    _document.webkitFullscreenElement != null;

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

void exitFullscreenJS() {
  if (_isFullscreenJS) {
    try {
      _document.exitFullscreen();
    } catch (_) {
      // TODO: Currently failing silently, but could add user alerts or error handling based on requirements
    }
  }
}

void toggleFullscreenJS() {
  _isFullscreenJS ? exitFullscreenJS() : requestFullscreenJS();
}

/// Adds or updates the center image element
///
/// [url] The image URL to display
/// [style] CSS style string, defaults to kCenterImageStyle
///
/// The image will be centered and support fullscreen toggle on double click.
/// Silently handles any DOM manipulation errors to avoid breaking the app flow.
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
