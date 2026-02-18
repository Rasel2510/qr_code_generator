# QR Code Generator

A Flutter package for generating dynamic QR codes with custom colors using CustomPainter.

## Features

- Generate QR codes from any string data
- Customize dark and light colors
- Adjustable size
- Lightweight implementation using CustomPainter
- Built-in error handling

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  qr_code_generator: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:qr_code_generator/qr_code_generator.dart';
```

### Basic Example

```dart
DynamicQrPainterWidget(
  data: 'https://example.com',
  size: 200,
)
```

### Custom Colors

```dart
DynamicQrPainterWidget(
  data: 'Hello, World!',
  size: 250,
  darkColor: Colors.blue,
  lightColor: Colors.yellow,
)
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:qr_code_generator/qr_code_generator.dart';

class QrCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: DynamicQrPainterWidget(
          data: 'https://flutter.dev',
          size: 300,
          darkColor: Colors.black,
          lightColor: Colors.white,
        ),
      ),
    );
  }
}
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `String` | required | The data to encode in the QR code |
| `size` | `double` | `200` | The size of the QR code (width and height) |
| `darkColor` | `Color` | `Colors.black` | Color for dark modules |
| `lightColor` | `Color` | `Colors.white` | Color for light modules/background |

## Dependencies

This package depends on:
- [qr](https://pub.dev/packages/qr) - For QR code generation

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
