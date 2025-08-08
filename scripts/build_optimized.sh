#!/bin/bash

# Script build tối ưu cho Flutter app
# Giảm dung lượng APK và tối ưu hóa hiệu suất

set -e

echo "🚀 Starting optimized build process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting dependencies..."
flutter pub get

# Analyze code for issues
print_status "Analyzing code..."
flutter analyze

# Run tests if they exist
if [ -d "test" ]; then
    print_status "Running tests..."
    flutter test
fi

# Build for Android with optimizations
print_status "Building optimized Android APK..."

# Build APK with specific ABI to reduce size
flutter build apk \
    --release \
    --target-platform android-arm64 \
    --split-per-abi \
    --obfuscate \
    --split-debug-info=build/debug-info \
    --dart-define=FLUTTER_WEB_USE_SKIA=true

# Build App Bundle (recommended for Play Store)
print_status "Building Android App Bundle..."
flutter build appbundle \
    --release \
    --target-platform android-arm64 \
    --obfuscate \
    --split-debug-info=build/debug-info

# Build for iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Building for iOS..."
    flutter build ios \
        --release \
        --no-codesign \
        --obfuscate \
        --split-debug-info=build/debug-info
fi

# Show build results
print_success "Build completed successfully!"

# Show APK sizes
if [ -f "build/app/outputs/flutter-apk/app-arm64-release.apk" ]; then
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-arm64-release.apk | cut -f1)
    print_success "APK size: $APK_SIZE"
fi

if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
    print_success "AAB size: $AAB_SIZE"
fi

# Show optimization tips
echo ""
print_status "Optimization tips:"
echo "1. Use 'flutter build apk --split-per-abi' to create smaller APKs per architecture"
echo "2. Enable R8/ProGuard in android/app/build.gradle"
echo "3. Use WebP format for images instead of PNG"
echo "4. Remove unused dependencies from pubspec.yaml"
echo "5. Use const constructors where possible"
echo "6. Enable tree shaking with --tree-shake-icons"

print_success "Build process completed! 🎉" 