#!/usr/bin/env bash
#
# Deploy script for ROBOTSTXT plugins
#
# Usage: ./bin/deploy.sh <version>
# Example: ./bin/deploy.sh 1.2.0
#
# This script creates a clean, production-ready ZIP file of the plugin
# in the ../plugins/ directory, excluding all development files.

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if version argument is provided
if [ -z "$1" ]; then
    print_error "Version argument is required"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.2.0"
    exit 1
fi

VERSION="$1"

# Validate version format (semver)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format. Expected: X.Y.Z (e.g., 1.2.0)"
    exit 1
fi

# Get plugin directory (parent of bin/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
PLUGIN_SLUG="$(basename "$PLUGIN_DIR")"

# Output directory (../plugins/ relative to plugin root)
OUTPUT_DIR="$(dirname "$PLUGIN_DIR")"
OUTPUT_FILE="${OUTPUT_DIR}/${PLUGIN_SLUG}-${VERSION}.zip"

# Temporary build directory
BUILD_DIR="/tmp/${PLUGIN_SLUG}-build-$$"
BUILD_PLUGIN_DIR="${BUILD_DIR}/${PLUGIN_SLUG}"

print_info "Deploying ${PLUGIN_SLUG} v${VERSION}"
echo ""

# Verify plugin main file exists
MAIN_FILE="${PLUGIN_DIR}/${PLUGIN_SLUG}.php"
if [ ! -f "$MAIN_FILE" ]; then
    print_error "Main plugin file not found: ${MAIN_FILE}"
    exit 1
fi

# Check if version matches in main plugin file
PLUGIN_VERSION=$(grep -oP "^\s*\*\s*Version:\s*\K[0-9]+\.[0-9]+\.[0-9]+" "$MAIN_FILE" || echo "")
if [ "$PLUGIN_VERSION" != "$VERSION" ]; then
    print_warning "Version mismatch!"
    print_warning "  Script version: ${VERSION}"
    print_warning "  Plugin file version: ${PLUGIN_VERSION}"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Deployment cancelled"
        exit 1
    fi
fi

# Check if update.json version matches
UPDATE_JSON="${PLUGIN_DIR}/update.json"
if [ -f "$UPDATE_JSON" ]; then
    JSON_VERSION=$(grep -oP '"version":\s*"\K[0-9]+\.[0-9]+\.[0-9]+' "$UPDATE_JSON" || echo "")
    if [ "$JSON_VERSION" != "$VERSION" ]; then
        print_warning "update.json version mismatch!"
        print_warning "  Script version: ${VERSION}"
        print_warning "  JSON version: ${JSON_VERSION}"
    fi
fi

print_info "Creating build directory..."
mkdir -p "$BUILD_PLUGIN_DIR"

print_info "Copying plugin files..."

# Copy files using rsync with exclusions
rsync -a \
    --exclude='.git/' \
    --exclude='.github/' \
    --exclude='.gitignore' \
    --exclude='.gitattributes' \
    --exclude='.claude/' \
    --exclude='.vscode/' \
    --exclude='.idea/' \
    --exclude='bin/' \
    --exclude='tests/' \
    --exclude='node_modules/' \
    --exclude='vendor/' \
    --exclude='composer.json' \
    --exclude='composer.lock' \
    --exclude='package.json' \
    --exclude='package-lock.json' \
    --exclude='phpunit.xml' \
    --exclude='phpunit.xml.dist' \
    --exclude='phpcs.xml' \
    --exclude='phpcs.xml.dist' \
    --exclude='phpstan.neon' \
    --exclude='phpstan.neon.dist' \
    --exclude='.phpcs.xml' \
    --exclude='.phpstan.neon' \
    --exclude='psalm.xml' \
    --exclude='.psalm.xml' \
    --exclude='webpack.config.js' \
    --exclude='gulpfile.js' \
    --exclude='Gruntfile.js' \
    --exclude='.editorconfig' \
    --exclude='.eslintrc' \
    --exclude='.eslintrc.js' \
    --exclude='.prettierrc' \
    --exclude='.stylelintrc' \
    --exclude='.DS_Store' \
    --exclude='Thumbs.db' \
    --exclude='*.log' \
    --exclude='*.md' \
    --exclude='CHANGELOG.md' \
    --exclude='UPDATER-README.md' \
    --exclude='UPDATER-TEMPLATE.txt' \
    --exclude='update.json.example' \
    --exclude='*.zip' \
    --exclude='*.tar.gz' \
    --exclude='*.tar' \
    --exclude='*.bak' \
    --exclude='*.swp' \
    --exclude='*.swo' \
    --exclude='*~' \
    --exclude='*.code-workspace' \
    "$PLUGIN_DIR/" "$BUILD_PLUGIN_DIR/"

print_success "Files copied"

# Verify critical files exist in build
print_info "Verifying build..."

CRITICAL_FILES=(
    "${PLUGIN_SLUG}.php"
    "robotstxt-updater.php"
    "update.json"
    "readme.txt"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "${BUILD_PLUGIN_DIR}/${file}" ]; then
        print_error "Critical file missing in build: ${file}"
        rm -rf "$BUILD_DIR"
        exit 1
    fi
done

print_success "Build verified"

# Create ZIP file
print_info "Creating ZIP archive..."

cd "$BUILD_DIR"

if command -v zip &> /dev/null; then
    # Use zip command if available (preserves symlinks and permissions better)
    zip -r -q "${OUTPUT_FILE}" "${PLUGIN_SLUG}/"
else
    print_error "zip command not found. Please install zip utility."
    rm -rf "$BUILD_DIR"
    exit 1
fi

print_success "ZIP created"

# Get file size
FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)

# Clean up
print_info "Cleaning up..."
rm -rf "$BUILD_DIR"
print_success "Build directory cleaned"

echo ""
print_success "Deployment complete!"
echo ""
echo "  Plugin: ${PLUGIN_SLUG}"
echo "  Version: ${VERSION}"
echo "  Output: ${OUTPUT_FILE}"
echo "  Size: ${FILE_SIZE}"
echo ""

# Verify ZIP contents
print_info "ZIP contents:"
unzip -l "$OUTPUT_FILE" | head -20

echo ""
print_success "Ready to upload!"
echo ""
print_info "Next steps:"
echo "  1. Test the ZIP: Install it on a WordPress test site"
echo "  2. Create Git tag: git tag v${VERSION} && git push --tags"
echo "  3. Upload to server: scp ${OUTPUT_FILE} your-server:/path/"
echo ""
