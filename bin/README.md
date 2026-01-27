# Deployment Scripts

Scripts for building and deploying the ROBOTSTXT Hello plugin.

## Quick Start

### Option 1: Full Release Process (Recommended)

```bash
# One command to rule them all
./bin/release.sh 1.2.0
```

This will:
1. Validate version consistency
2. Create deployment ZIP
3. Create Git tag
4. Prompt to push to remote
5. Show instructions for Gitea release

### Option 2: Manual Step-by-Step

```bash
# 1. Validate
./bin/validate.sh 1.2.0

# 2. Create ZIP
./bin/deploy.sh 1.2.0

# 3. Create tag manually
git tag v1.2.0 && git push --tags

# 4. Upload ZIP to Gitea release
```

## Scripts

### release.sh

**Complete release automation script** (recommended for full releases).

#### Usage

```bash
./bin/release.sh <version>
```

#### Example

```bash
./bin/release.sh 1.2.0
```

#### What it does

1. **Validates** using `validate.sh`
2. **Creates ZIP** using `deploy.sh`
3. **Creates Git tag** (v1.2.0)
4. **Prompts to push** to remote
5. **Shows Gitea release instructions** with the exact URL format
6. **Provides verification commands** for testing the update system

This is the easiest way to release a new version. It combines all steps and provides guidance for the Gitea release creation.

---

### validate.sh

Pre-deployment validation script that checks version consistency and common issues.

#### Usage

```bash
./bin/validate.sh [version]
```

#### Example

```bash
./bin/validate.sh 1.2.0
```

#### What it checks

**Version Consistency:**
- Main plugin file header (`Version:`)
- `update.json` (`version` field)
- `update.json` (`download_url` format: `.../releases/download/VERSION/plugin-VERSION.zip`)
- `readme.txt` (`Stable tag:` and `Version:`)
- `changelog.txt` (entry for version)

**Required Files:**
- Main plugin file exists
- `robotstxt-updater.php` exists
- `update.json` exists
- Updater is initialized in main file

**Code Quality:**
- No debugging code (`var_dump`, `print_r`, etc.)
- No TODO/FIXME comments in production code

#### Exit Codes

- `0` - Validation passed (may have warnings)
- `1` - Validation failed (errors found)

---

## deploy.sh

Creates a production-ready ZIP file of the plugin, excluding all development files.

### Usage

```bash
./bin/deploy.sh <version>
```

### Example

```bash
./bin/deploy.sh 1.2.0
```

### What it does

1. **Validates** the version format (semver: X.Y.Z)
2. **Checks** version consistency between:
   - Script argument
   - Plugin header (`Version:`)
   - `update.json` file
3. **Creates** a temporary build directory
4. **Copies** only production files (excludes dev dependencies, tests, etc.)
5. **Verifies** critical files are present
6. **Creates** a ZIP file: `robotstxt-hello-VERSION.zip`
7. **Places** the ZIP in the parent directory (`../`)
8. **Cleans up** temporary files
9. **Displays** ZIP contents and next steps

### Output Location

The ZIP file is created in the parent directory of the plugin:

```
/wp-content/plugins/
├── robotstxt-hello/           ← Plugin directory
└── robotstxt-hello-1.2.0.zip  ← Generated ZIP
```

### Excluded Files

The script automatically excludes:

**Development files:**
- `.git/`, `.github/`
- `.gitignore`, `.gitattributes`
- `bin/`, `tests/`
- `vendor/`, `node_modules/`
- `composer.json`, `composer.lock`
- `package.json`, `package-lock.json`

**IDE/Editor files:**
- `.vscode/`, `.idea/`, `.claude/`
- `*.code-workspace`
- `.editorconfig`

**Build/Config files:**
- `phpunit.xml`, `phpcs.xml`, `phpstan.neon`
- `webpack.config.js`, `gulpfile.js`, `Gruntfile.js`
- `.eslintrc`, `.prettierrc`, `.stylelintrc`

**Documentation (dev-only):**
- `*.md` (all Markdown files)
- `CHANGELOG.md`
- `UPDATER-README.md`
- `UPDATER-TEMPLATE.txt`
- `update.json.example`

**Temporary/System files:**
- `.DS_Store`, `Thumbs.db`
- `*.log`, `*.bak`, `*.swp`, `*~`
- `*.zip`, `*.tar.gz`

### Included Files

Only production-ready files are included:

```
robotstxt-hello/
├── robotstxt-hello.php       ← Main plugin file
├── robotstxt-updater.php     ← Auto-updater
├── update.json               ← Update manifest
├── readme.txt                ← WordPress readme
├── changelog.txt             ← Changelog
├── LICENSE                   ← License file
├── includes/                 ← PHP classes
│   └── *.php
└── languages/                ← Translation files
    ├── *.po
    └── *.mo
```

### ZIP Structure

The generated ZIP has the correct WordPress plugin structure:

```
robotstxt-hello-1.2.0.zip
└── robotstxt-hello/          ← Root folder matches plugin slug
    ├── robotstxt-hello.php
    ├── robotstxt-updater.php
    ├── update.json
    ├── readme.txt
    ├── changelog.txt
    ├── LICENSE
    ├── includes/
    └── languages/
```

This structure allows WordPress to install the plugin correctly.

### Verification

The script automatically verifies:

1. **Version format** is valid semver (X.Y.Z)
2. **Main plugin file** exists
3. **Critical files** are present in the build:
   - `robotstxt-hello.php`
   - `robotstxt-updater.php`
   - `update.json`
   - `readme.txt`
4. **Version consistency** (warns if mismatched)

### Next Steps After Deployment

After running the script successfully:

1. **Test the ZIP**
   ```bash
   # Install on a test WordPress site to verify functionality
   ```

2. **Create Git tag**
   ```bash
   git tag v1.2.0
   git push origin main --tags
   ```

3. **Upload to Gitea**
   - Create a release for the tag with the deployment ZIP attached
   - Verify: `https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.0/robotstxt-hello-1.2.0.zip`

4. **Test the updater**
   - Install an older version on a test site
   - Trigger update check: `/wp-admin/?robotstxt_clear_update_cache=1`
   - Verify update appears and installs correctly

### Troubleshooting

**"zip command not found"**
```bash
# Ubuntu/Debian
sudo apt-get install zip

# CentOS/RHEL
sudo yum install zip

# macOS (should be pre-installed)
brew install zip
```

**"Version mismatch" warning**

Update all version references:
1. Plugin header: `Version: 1.2.0`
2. `update.json`: `"version": "1.2.0"`
3. `readme.txt`: `Stable tag: 1.2.0`

**"Critical file missing"**

Ensure all required files exist in the plugin directory before running the script.

### Customization

To customize what files are included/excluded, edit the `rsync` command in `deploy.sh`:

```bash
# Add more exclusions
--exclude='custom-folder/' \

# Remove an exclusion (comment it out)
# --exclude='tests/' \
```

### Requirements

- `bash` 4.0+
- `rsync` (for efficient file copying)
- `zip` (for creating archives)
- `grep` with PCRE support (`-P` flag)

All of these are standard on modern Linux/Unix systems.
