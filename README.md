# Flutter Web App with JavaScript Interop

A Flutter web application that demonstrates JavaScript interop capabilities by providing fullscreen control and dynamic image loading functionality.

## Features

This application showcases:
* JavaScript interop for browser control
* Dynamic image loading and display
* Fullscreen mode management
* Overlay menu system

## Libraries

### Main Application
The main application provides a web interface for loading and displaying images with fullscreen capabilities and an overlay menu system.

### JavaScript Interop Utilities
Provides JavaScript interoperability utilities for browser control, specifically focused on fullscreen functionality and DOM manipulation.

This library wraps browser APIs to provide type-safe access to:
* Fullscreen mode controls
* DOM element creation and manipulation
* Event listener management

Example usage:
```dart
// Toggle fullscreen mode
toggleFullscreenJS();

// Display an image centered on screen
addCenterImageJS('https://example.com/image.jpg');
