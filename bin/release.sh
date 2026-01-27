#!/usr/bin/env bash
#
# Release script for ROBOTSTXT plugins
#
# Usage: ./bin/release.sh <version>
# Example: ./bin/release.sh 1.2.0
#
# This script:
# 1. Validates version consistency
# 2. Creates deployment ZIP
# 3. Creates Git tag
# 4. Shows instructions for uploading to Gitea

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

print_step() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

if [ -z "$1" ]; then
    print_error "Version argument is required"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.2.0"
    exit 1
fi

VERSION="$1"

# Get plugin directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
PLUGIN_SLUG="$(basename "$PLUGIN_DIR")"
OUTPUT_DIR="$(dirname "$PLUGIN_DIR")"
ZIP_FILE="${OUTPUT_DIR}/${PLUGIN_SLUG}-${VERSION}.zip"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          ROBOTSTXT Plugin Release Process                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  Plugin: ${PLUGIN_SLUG}"
echo "  Version: ${VERSION}"
echo ""

# Step 1: Validate
print_step "STEP 1: Validation"

if [ -f "${SCRIPT_DIR}/validate.sh" ]; then
    "${SCRIPT_DIR}/validate.sh" "$VERSION"
else
    print_error "validate.sh not found"
    exit 1
fi

# Step 2: Create ZIP
print_step "STEP 2: Create Deployment ZIP"

if [ -f "${SCRIPT_DIR}/deploy.sh" ]; then
    "${SCRIPT_DIR}/deploy.sh" "$VERSION"
else
    print_error "deploy.sh not found"
    exit 1
fi

if [ ! -f "$ZIP_FILE" ]; then
    print_error "ZIP file was not created: ${ZIP_FILE}"
    exit 1
fi

print_success "ZIP created: ${ZIP_FILE}"

# Step 3: Git operations
print_step "STEP 3: Git Tag"

# Check if tag already exists
if git rev-parse "v${VERSION}" >/dev/null 2>&1; then
    print_warning "Tag v${VERSION} already exists"
    read -p "Delete existing tag and recreate? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -d "v${VERSION}"
        print_success "Deleted local tag v${VERSION}"
    else
        print_error "Cannot proceed with existing tag"
        exit 1
    fi
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes"
    git status --short
    echo ""
    read -p "Commit all changes? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        git commit -m "Release v${VERSION}"
        print_success "Changes committed"
    else
        print_error "Please commit changes before creating release"
        exit 1
    fi
fi

# Create tag
git tag -a "v${VERSION}" -m "Release version ${VERSION}"
print_success "Created tag v${VERSION}"

# Step 4: Push instructions
print_step "STEP 4: Push to Remote"

print_info "Ready to push. Run the following commands:"
echo ""
echo "  git push origin main"
echo "  git push origin v${VERSION}"
echo ""

read -p "Push now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin main
    git push origin "v${VERSION}"
    print_success "Pushed to remote"
else
    print_warning "Remember to push manually:"
    echo "  git push origin main && git push origin v${VERSION}"
fi

# Step 5: Gitea Release instructions
print_step "STEP 5: Create Gitea Release"

echo "Now create the release on Gitea:"
echo ""
echo "  1. Go to: https://git.robotstxt.es/${PLUGIN_SLUG}/releases/new"
echo "  2. Select tag: v${VERSION}"
echo "  3. Release title: v${VERSION}"
echo "  4. Release notes: Copy from changelog.txt"
echo "  5. Upload the ZIP file:"
echo "     ${ZIP_FILE}"
echo "  6. Publish release"
echo ""
echo "The release URL will be:"
echo "  https://git.robotstxt.es/ROBOTSTXT/${PLUGIN_SLUG}/releases/download/${VERSION}/${PLUGIN_SLUG}-${VERSION}.zip"
echo ""

# Step 6: Verification
print_step "STEP 6: Verify Update System"

echo "After creating the Gitea release:"
echo ""
echo "  1. Verify the ZIP is accessible:"
echo "     curl -I https://git.robotstxt.es/ROBOTSTXT/${PLUGIN_SLUG}/releases/download/${VERSION}/${PLUGIN_SLUG}-${VERSION}.zip"
echo ""
echo "  2. Test on a WordPress site with older version:"
echo "     - Go to /wp-admin/?robotstxt_clear_update_cache=1"
echo "     - Check Plugins → Updates"
echo "     - Update should appear"
echo ""

# Final summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Release Process Complete!                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  ✓ Validation passed"
echo "  ✓ ZIP created: ${ZIP_FILE}"
echo "  ✓ Git tag created: v${VERSION}"
echo ""
print_warning "Don't forget to create the Gitea release and upload the ZIP!"
echo ""
