## 1.0.2

### Added
- **Center Image Support:**
  - Optional circular center image/logo in QR code center
  - Customizable center image size (defaults to 20% of QR size)
  - Adjustable border around center image with custom color and width
  - Auto-exclusion of QR modules in center area for better scannability
  - Support for all ImageProvider types (AssetImage, NetworkImage, FileImage, MemoryImage)
  
- **QR Code Styling:**
  - Multiple module shapes: square (default), dot, rounded, diamond, and heart
  - Customizable module gap spacing for modern dot/rounded styles
  - Anti-aliasing for smoother shape rendering
  
- **Smart Features:**
  - Automatic error correction level adjustment based on center image size
  - Improved distance calculation for center image exclusion
  - Enhanced image loading with FutureBuilder for better performance

### Changed
- Improved error handling for image loading failures
- Better module rendering with shape-specific optimizations
- Enhanced QR code scannability with intelligent error correction

### Parameters Added
- `centerImage` - Optional image to display in center
- `centerImageSize` - Size of the center image
- `centerImageBorderColor` - Border color around center image
- `centerImageBorderWidth` - Border width around center image
- `moduleShape` - Shape style of QR modules (enum)
- `moduleGap` - Spacing between modules for dot/rounded styles

## 1.0.1

### Changed
- Updated README file for clarity and better instructions

## 1.0.0

### Added
- Initial stable release
- Generate QR codes using CustomPainter
- Customizable dark and light colors
- Adjustable QR code size
- Error handling for QR generation failures