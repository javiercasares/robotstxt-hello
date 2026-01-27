#!/usr/bin/env bash
#
# Validation script for ROBOTSTXT plugins before deployment
#
# Usage: ./bin/validate.sh [version]
# Example: ./bin/validate.sh 1.2.0
#
# This script checks that all version numbers are consistent
# and that all required files are present before deployment.

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

# Get plugin directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
PLUGIN_SLUG="$(basename "$PLUGIN_DIR")"
MAIN_FILE="${PLUGIN_DIR}/${PLUGIN_SLUG}.php"

print_info "Validating ${PLUGIN_SLUG} plugin..."
echo ""

ERRORS=0
WARNINGS=0

# Check if main file exists
if [ ! -f "$MAIN_FILE" ]; then
    print_error "Main plugin file not found: ${MAIN_FILE}"
    exit 1
fi

# Extract version from main plugin file
PLUGIN_VERSION=$(grep -oP "^\s*\*\s*Version:\s*\K[0-9]+\.[0-9]+\.[0-9]+" "$MAIN_FILE" || echo "")
if [ -z "$PLUGIN_VERSION" ]; then
    print_error "Could not find Version in ${MAIN_FILE}"
    ((ERRORS++))
else
    print_success "Plugin version: ${PLUGIN_VERSION}"
fi

# If version argument provided, validate against it
if [ -n "$1" ]; then
    EXPECTED_VERSION="$1"
    print_info "Checking against expected version: ${EXPECTED_VERSION}"
    echo ""
fi

# Check update.json
UPDATE_JSON="${PLUGIN_DIR}/update.json"
if [ ! -f "$UPDATE_JSON" ]; then
    print_error "update.json not found"
    ((ERRORS++))
else
    JSON_VERSION=$(grep -oP '"version":\s*"\K[0-9]+\.[0-9]+\.[0-9]+' "$UPDATE_JSON" || echo "")
    if [ -z "$JSON_VERSION" ]; then
        print_error "Could not find version in update.json"
        ((ERRORS++))
    elif [ "$JSON_VERSION" != "$PLUGIN_VERSION" ]; then
        print_error "update.json version mismatch: ${JSON_VERSION} != ${PLUGIN_VERSION}"
        ((ERRORS++))
    else
        print_success "update.json version: ${JSON_VERSION}"
    fi

    # Check download_url
    DOWNLOAD_URL=$(grep -oP '"download_url":\s*"\K[^"]+' "$UPDATE_JSON" || echo "")
    if [ -z "$DOWNLOAD_URL" ]; then
        print_error "download_url not found in update.json"
        ((ERRORS++))
    else
        # Verify it's the correct format: .../releases/download/VERSION/plugin-VERSION.zip
        if [[ ! "$DOWNLOAD_URL" =~ /releases/download/${PLUGIN_VERSION}/${PLUGIN_SLUG}-${PLUGIN_VERSION}\.zip$ ]]; then
            print_error "download_url has incorrect format"
            print_error "Expected: .../releases/download/${PLUGIN_VERSION}/${PLUGIN_SLUG}-${PLUGIN_VERSION}.zip"
            print_error "Got: ${DOWNLOAD_URL}"
            ((ERRORS++))
        else
            print_success "download_url: ${DOWNLOAD_URL}"
        fi
    fi
fi

# Check readme.txt
README_TXT="${PLUGIN_DIR}/readme.txt"
if [ ! -f "$README_TXT" ]; then
    print_warning "readme.txt not found"
    ((WARNINGS++))
else
    README_STABLE=$(grep -oP "^Stable tag:\s*\K[0-9]+\.[0-9]+\.[0-9]+" "$README_TXT" || echo "")
    README_VERSION=$(grep -oP "^Version:\s*\K[0-9]+\.[0-9]+\.[0-9]+" "$README_TXT" || echo "")

    if [ -n "$README_STABLE" ] && [ "$README_STABLE" != "$PLUGIN_VERSION" ]; then
        print_error "readme.txt Stable tag mismatch: ${README_STABLE} != ${PLUGIN_VERSION}"
        ((ERRORS++))
    elif [ -n "$README_STABLE" ]; then
        print_success "readme.txt Stable tag: ${README_STABLE}"
    fi

    if [ -n "$README_VERSION" ] && [ "$README_VERSION" != "$PLUGIN_VERSION" ]; then
        print_error "readme.txt Version mismatch: ${README_VERSION} != ${PLUGIN_VERSION}"
        ((ERRORS++))
    elif [ -n "$README_VERSION" ]; then
        print_success "readme.txt Version: ${README_VERSION}"
    fi
fi

# Check changelog.txt
CHANGELOG_TXT="${PLUGIN_DIR}/changelog.txt"
if [ ! -f "$CHANGELOG_TXT" ]; then
    print_warning "changelog.txt not found"
    ((WARNINGS++))
else
    if grep -q "= ${PLUGIN_VERSION} =" "$CHANGELOG_TXT"; then
        print_success "changelog.txt has entry for ${PLUGIN_VERSION}"
    else
        print_error "changelog.txt missing entry for ${PLUGIN_VERSION}"
        ((ERRORS++))
    fi
fi

# Check robotstxt-updater.php
UPDATER_FILE="${PLUGIN_DIR}/robotstxt-updater.php"
if [ ! -f "$UPDATER_FILE" ]; then
    print_error "robotstxt-updater.php not found"
    ((ERRORS++))
else
    print_success "robotstxt-updater.php exists"
fi

# Check if version is used in main file
if ! grep -q "Robotstxt_Updater::init" "$MAIN_FILE"; then
    print_warning "Main file may not initialize updater"
    ((WARNINGS++))
else
    print_success "Updater initialized in main file"
fi

# Check for common mistakes
print_info "Checking for common issues..."

# Check for debugging code
if grep -rn --include="*.php" "var_dump\|print_r\|var_export\|dd(" "$PLUGIN_DIR/includes/" 2>/dev/null | grep -v "vendor/"; then
    print_warning "Debugging code found (var_dump, print_r, etc.)"
    ((WARNINGS++))
else
    print_success "No debugging code found"
fi

# Check for TODO/FIXME comments
if grep -rn --include="*.php" "TODO\|FIXME" "$PLUGIN_DIR/includes/" 2>/dev/null | grep -v "vendor/"; then
    print_warning "TODO/FIXME comments found"
    ((WARNINGS++))
else
    print_success "No TODO/FIXME comments found"
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    print_success "Validation passed! Ready to deploy."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    print_warning "Validation passed with ${WARNINGS} warning(s)"
    exit 0
else
    print_error "Validation failed with ${ERRORS} error(s) and ${WARNINGS} warning(s)"
    exit 1
fi
