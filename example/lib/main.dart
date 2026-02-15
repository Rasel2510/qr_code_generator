import 'package:flutter/material.dart';
import 'package:qr_code_generator/qr_code_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Generator Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QrCodeExampleScreen(),
    );
  }
}

class QrCodeExampleScreen extends StatefulWidget {
  const QrCodeExampleScreen({super.key});

  @override
  State<QrCodeExampleScreen> createState() => _QrCodeExampleScreenState();
}

class _QrCodeExampleScreenState extends State<QrCodeExampleScreen> {
  final TextEditingController _controller = TextEditingController(
    text: 'https://flutter.dev',
  );
  String _qrData = 'https://flutter.dev';
  Color _darkColor = Colors.black;
  Color _lightColor = Colors.white;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QR Code Generator Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // QR Code Display
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DynamicQrPainterWidget(
                  data: _qrData,
                  size: 250,
                  darkColor: _darkColor,
                  lightColor: _lightColor,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Input Field
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter data for QR code',
                border: OutlineInputBorder(),
                hintText: 'https://example.com',
              ),
              onChanged: (value) {
                setState(() {
                  _qrData = value.isEmpty ? 'Empty' : value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Color Customization
            const Text(
              'Dark Color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildColorButton(Colors.black, 'Black'),
                _buildColorButton(Colors.blue, 'Blue'),
                _buildColorButton(Colors.red, 'Red'),
                _buildColorButton(Colors.green, 'Green'),
                _buildColorButton(Colors.purple, 'Purple'),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Light Color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildLightColorButton(Colors.white, 'White'),
                _buildLightColorButton(Colors.yellow[100]!, 'Yellow'),
                _buildLightColorButton(Colors.pink[50]!, 'Pink'),
                _buildLightColorButton(Colors.blue[50]!, 'Light Blue'),
                _buildLightColorButton(Colors.green[50]!, 'Light Green'),
              ],
            ),
            const SizedBox(height: 24),

            // Preset Examples
            const Text(
              'Quick Examples:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _controller.text = 'https://flutter.dev';
                setState(() {
                  _qrData = 'https://flutter.dev';
                  _darkColor = Colors.black;
                  _lightColor = Colors.white;
                });
              },
              child: const Text('Flutter Website'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.text = 'mailto:example@email.com';
                setState(() {
                  _qrData = 'mailto:example@email.com';
                  _darkColor = Colors.blue;
                  _lightColor = Colors.white;
                });
              },
              child: const Text('Email Address'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.text = 'tel:+1234567890';
                setState(() {
                  _qrData = 'tel:+1234567890';
                  _darkColor = Colors.green;
                  _lightColor = Colors.white;
                });
              },
              child: const Text('Phone Number'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _darkColor == color,
      selectedColor: color.withValues(alpha: 0.3),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _darkColor = color;
          });
        }
      },
    );
  }

  Widget _buildLightColorButton(Color color, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _lightColor == color,
      backgroundColor: color,
      selectedColor: color,
      side: BorderSide(
        color: _lightColor == color ? Colors.blue : Colors.grey,
        width: _lightColor == color ? 2 : 1,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _lightColor = color;
          });
        }
      },
    );
  }
}
