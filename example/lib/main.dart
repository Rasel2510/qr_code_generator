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
      debugShowCheckedModeBanner: false,
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

  // Center image settings
  bool _showCenterImage = false;
  ImageProvider? _centerImage;
  double _centerImageSize = 60;
  Color _centerImageBorderColor = Colors.white;
  double _centerImageBorderWidth = 6;

  // QR Style settings
  QrModuleShape _moduleShape = QrModuleShape.square;

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
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DynamicQrPainterWidget(
                  data: _qrData,
                  size: 300,
                  darkColor: _darkColor,
                  lightColor: _lightColor,
                  moduleShape: _moduleShape,
                  centerImage: _showCenterImage ? _centerImage : null,
                  centerImageSize: _centerImageSize,
                  centerImageBorderColor: _centerImageBorderColor,
                  centerImageBorderWidth: _centerImageBorderWidth,
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
                prefixIcon: Icon(Icons.qr_code),
              ),
              onChanged: (value) {
                setState(() {
                  _qrData = value.isEmpty ? 'Empty' : value;
                });
              },
            ),
            const SizedBox(height: 24),

            // QR Style Selection
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QR Code Style',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Square'),
                          avatar: const Icon(Icons.square_outlined, size: 18),
                          selected: _moduleShape == QrModuleShape.square,
                          onSelected: (selected) {
                            if (selected) {
                              setState(
                                  () => _moduleShape = QrModuleShape.square);
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Dots'),
                          avatar: const Icon(Icons.circle_outlined, size: 18),
                          selected: _moduleShape == QrModuleShape.dot,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _moduleShape = QrModuleShape.dot);
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Rounded'),
                          avatar: const Icon(Icons.rounded_corner, size: 18),
                          selected: _moduleShape == QrModuleShape.rounded,
                          onSelected: (selected) {
                            if (selected) {
                              setState(
                                  () => _moduleShape = QrModuleShape.rounded);
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Diamond'),
                          avatar: const Icon(Icons.diamond_outlined, size: 18),
                          selected: _moduleShape == QrModuleShape.diamond,
                          onSelected: (selected) {
                            if (selected) {
                              setState(
                                  () => _moduleShape = QrModuleShape.diamond);
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Heart'),
                          avatar: const Icon(Icons.favorite_border, size: 18),
                          selected: _moduleShape == QrModuleShape.heart,
                          onSelected: (selected) {
                            if (selected) {
                              setState(
                                  () => _moduleShape = QrModuleShape.heart);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Center Image Toggle
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Center Image / Logo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: _showCenterImage,
                          onChanged: (value) {
                            setState(() {
                              _showCenterImage = value;
                              if (value && _centerImage == null) {
                                _centerImage = const NetworkImage(
                                  'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_showCenterImage) ...[
                      const Divider(height: 24),
                      const Text(
                        'Image Source:',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Flutter'),
                            avatar: const Icon(Icons.flutter_dash, size: 16),
                            selected: _centerImage is NetworkImage &&
                                (_centerImage as NetworkImage)
                                    .url
                                    .contains('flutter'),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _centerImage = const NetworkImage(
                                    'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
                                  );
                                });
                              }
                            },
                          ),
                          ChoiceChip(
                            label: const Text('GitHub'),
                            avatar: const Icon(Icons.code, size: 16),
                            selected: _centerImage is NetworkImage &&
                                (_centerImage as NetworkImage)
                                    .url
                                    .contains('github'),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _centerImage = const NetworkImage(
                                    'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
                                  );
                                });
                              }
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Bird 🐦'),
                            selected: _centerImage is NetworkImage &&
                                (_centerImage as NetworkImage)
                                    .url
                                    .contains('unsplash'),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _centerImage = const NetworkImage(
                                    'https://images.pexels.com/photos/45853/grey-crowned-crane-bird-crane-animal-45853.jpeg',
                                  );
                                });
                              }
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Avatar'),
                            avatar: const Icon(Icons.person, size: 16),
                            selected: _centerImage is NetworkImage &&
                                (_centerImage as NetworkImage)
                                    .url
                                    .contains('pravatar'),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _centerImage = const NetworkImage(
                                    'https://i.pravatar.cc/150?img=12',
                                  );
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Image Size: ${_centerImageSize.toInt()}px',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Slider(
                        value: _centerImageSize,
                        min: 40,
                        max: 120,
                        divisions: 16,
                        label: _centerImageSize.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            _centerImageSize = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Border Width: ${_centerImageBorderWidth.toInt()}px',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Slider(
                        value: _centerImageBorderWidth,
                        min: 0,
                        max: 12,
                        divisions: 12,
                        label: _centerImageBorderWidth.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            _centerImageBorderWidth = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Border Color:',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildBorderColorButton(Colors.white, 'White'),
                          _buildBorderColorButton(Colors.black, 'Black'),
                          _buildBorderColorButton(Colors.blue, 'Blue'),
                          _buildBorderColorButton(Colors.red, 'Red'),
                          _buildBorderColorButton(Colors.yellow, 'Yellow'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Color Customization
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QR Code Colors',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Dark Color:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildLightColorButton(Colors.white, 'White'),
                        _buildLightColorButton(Colors.yellow[100]!, 'Yellow'),
                        _buildLightColorButton(Colors.pink[50]!, 'Pink'),
                        _buildLightColorButton(Colors.blue[50]!, 'Light Blue'),
                        _buildLightColorButton(
                            Colors.green[50]!, 'Light Green'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Preset Examples
            const Text(
              'Quick Presets:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                _controller.text = 'https://flutter.dev';
                setState(() {
                  _qrData = 'https://flutter.dev';
                  _darkColor = Colors.blue;
                  _lightColor = Colors.blue[50]!;
                  _showCenterImage = true;
                  _moduleShape = QrModuleShape.dot;
                  _centerImage = const NetworkImage(
                    'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
                  );
                  _centerImageSize = 70;
                  _centerImageBorderColor = Colors.white;
                  _centerImageBorderWidth = 8;
                });
              },
              icon: const Icon(Icons.flutter_dash),
              label: const Text('Flutter - Dots with Logo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                _controller.text = 'https://github.com';
                setState(() {
                  _qrData = 'https://github.com';
                  _darkColor = Colors.black;
                  _lightColor = Colors.white;
                  _showCenterImage = true;
                  _moduleShape = QrModuleShape.rounded;
                  _centerImage = const NetworkImage(
                    'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
                  );
                  _centerImageSize = 60;
                  _centerImageBorderColor = Colors.white;
                  _centerImageBorderWidth = 6;
                });
              },
              icon: const Icon(Icons.code),
              label: const Text('GitHub - Rounded with Logo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                _controller.text = 'mailto:example@email.com';
                setState(() {
                  _qrData = 'mailto:example@email.com';
                  _darkColor = Colors.red;
                  _lightColor = Colors.white;
                  _showCenterImage = false;
                  _moduleShape = QrModuleShape.square;
                });
              },
              icon: const Icon(Icons.email),
              label: const Text('Email Address'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                _controller.text = 'tel:+1234567890';
                setState(() {
                  _qrData = 'tel:+1234567890';
                  _darkColor = Colors.green;
                  _lightColor = Colors.white;
                  _showCenterImage = false;
                  _moduleShape = QrModuleShape.square;
                });
              },
              icon: const Icon(Icons.phone),
              label: const Text('Phone Number'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                _controller.text = 'WIFI:T:WPA;S:MyNetwork;P:password123;;';
                setState(() {
                  _qrData = 'WIFI:T:WPA;S:MyNetwork;P:password123;;';
                  _darkColor = Colors.purple;
                  _lightColor = Colors.purple[50]!;
                  _showCenterImage = false;
                  _moduleShape = QrModuleShape.diamond;
                });
              },
              icon: const Icon(Icons.wifi),
              label: const Text('WiFi Network - Diamond Style'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                _controller.text = 'I ❤️ Flutter';
                setState(() {
                  _qrData = 'I ❤️ Flutter';
                  _darkColor = Colors.pink;
                  _lightColor = Colors.pink[50]!;
                  _showCenterImage = true;
                  _moduleShape = QrModuleShape.heart;
                  _centerImage = const NetworkImage(
                    'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=150&h=150&fit=crop',
                  );
                  _centerImageSize = 50;
                  _centerImageBorderColor = Colors.pink;
                  _centerImageBorderWidth = 6;
                });
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Heart Style - Decorative'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
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

  Widget _buildBorderColorButton(Color color, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _centerImageBorderColor == color,
      selectedColor: color.withValues(alpha: 0.3),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(
        color: _centerImageBorderColor == color ? color : Colors.grey,
        width: _centerImageBorderColor == color ? 2 : 1,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _centerImageBorderColor = color;
          });
        }
      },
    );
  }
}
