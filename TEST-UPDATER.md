# Testing the Auto-Updater System

This document explains how to test the auto-updater with versions 1.2.0 and 1.2.1.

## Test Scenario

We have two versions ready:

- **v1.2.0** - Initial version with Auto-Updater system
- **v1.2.1** - Test release to validate the updater works

## Step-by-Step Testing Guide

### 1. Prepare the Releases on Gitea

#### Release v1.2.0 (Base version)

```bash
# Tag and push v1.2.0 (if not already done)
git tag v1.2.0
git push origin v1.2.0
```

On Gitea:
1. Go to: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/new
2. Select tag: `v1.2.0`
3. Title: `v1.2.0`
4. Description:
   ```
   Added generic JSON-based Auto-Updater system. Plugin now updates
   automatically from git.robotstxt.es without depending on WordPress.org repository.
   ```
5. Attach file: `robotstxt-hello-1.2.0.zip`
6. Publish release

Verify:
```bash
curl -I https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.0/robotstxt-hello-1.2.0.zip
# Should return: HTTP/2 200
```

#### Release v1.2.1 (Update test)

```bash
# Tag and push v1.2.1
git tag v1.2.1
git push origin v1.2.1
```

On Gitea:
1. Go to: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/new
2. Select tag: `v1.2.1`
3. Title: `v1.2.1`
4. Description:
   ```
   Test release to validate the Auto-Updater system is working correctly.
   ```
5. Attach file: `robotstxt-hello-1.2.1.zip`
6. Publish release

Verify:
```bash
curl -I https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.1/robotstxt-hello-1.2.1.zip
# Should return: HTTP/2 200
```

### 2. Update update.json on main branch

The `update.json` file in the main branch should point to v1.2.1:

```bash
# Verify current state
cat update.json | grep version
# Should show: "version": "1.2.1"

# Commit and push if needed
git add update.json
git commit -m "Update to v1.2.1"
git push origin main
```

Verify JSON is accessible:
```bash
curl https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/raw/branch/main/update.json
```

Should return:
```json
{
  "version": "1.2.1",
  "download_url": "https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.1/robotstxt-hello-1.2.1.zip",
  ...
}
```

### 3. Test on WordPress

#### Install v1.2.0 (Base version)

1. **Fresh WordPress Installation** (or use a test site)
2. **Install v1.2.0:**
   - Go to: WordPress Admin → Plugins → Add New → Upload Plugin
   - Upload: `robotstxt-hello-1.2.0.zip`
   - Click "Install Now"
   - Click "Activate Plugin"

3. **Verify installation:**
   - Go to: Plugins → Installed Plugins
   - Find "Hello (by ROBOTSTXT)"
   - Version should show: **1.2.0**

#### Trigger Update Check

1. **Clear update cache:**
   ```
   https://your-wp-site.com/wp-admin/?robotstxt_clear_update_cache=1
   ```

2. **Check for updates:**
   - Go to: Dashboard → Updates
   - Or: Plugins → Installed Plugins

3. **Expected Result:**
   - You should see: "Hello (by ROBOTSTXT)" with "Update Available"
   - New version: **1.2.1**

#### View Update Details

1. **Click "View version 1.2.1 details"** (or similar link)

2. **Expected Modal Content:**
   - Plugin Name: Hello (by ROBOTSTXT)
   - Version: 1.2.1
   - Changelog should show:
     ```
     • Test release to validate the Auto-Updater system is working correctly.
     • Added generic JSON-based Auto-Updater system...
     ```

#### Perform Update

1. **Click "Update Now"**

2. **WordPress will:**
   - Download from: `https://git.robotstxt.es/.../releases/download/1.2.1/robotstxt-hello-1.2.1.zip`
   - Extract and replace files
   - Show success message

3. **Verify update:**
   - Go to: Plugins → Installed Plugins
   - Version should now show: **1.2.1**
   - Plugin should still be active
   - No errors in WordPress debug log

### 4. Test Update Cache

#### Test Cache Duration (6 hours)

1. **Perform update check** (should show no updates)
2. **Manually change update.json** to a newer version (e.g., 1.2.2)
3. **Check for updates again** (should NOT see update yet - cached)
4. **Wait 6 hours** OR **clear cache:**
   ```
   https://your-wp-site.com/wp-admin/?robotstxt_clear_update_cache=1
   ```
5. **Check again** (should now see the new update)

#### Test Manual Cache Clear

```
# Method 1: URL parameter
https://your-wp-site.com/wp-admin/?robotstxt_clear_update_cache=1

# Method 2: Code
do_action('robotstxt_updater_clear_cache');
```

### 5. Expected Behavior Checklist

#### ✅ Update Detection

- [ ] Update is detected automatically (after cache expires or manual clear)
- [ ] Correct version number displayed (1.2.1)
- [ ] Update notification appears in Dashboard → Updates
- [ ] Update notification appears in Plugins list

#### ✅ Update Details Modal

- [ ] Modal opens when clicking "View details"
- [ ] Plugin name displayed correctly
- [ ] Version 1.2.1 displayed
- [ ] Changelog HTML rendered correctly
- [ ] Author information shown
- [ ] Homepage link present

#### ✅ Update Installation

- [ ] Update installs successfully
- [ ] Plugin version changes from 1.2.0 to 1.2.1
- [ ] Plugin remains active after update
- [ ] No PHP errors or warnings
- [ ] All plugin functionality works

#### ✅ Update URL

- [ ] Download URL format correct: `.../releases/download/1.2.1/robotstxt-hello-1.2.1.zip`
- [ ] File is accessible without authentication
- [ ] File size is correct (~32 KB)

#### ✅ Compatibility Checks

- [ ] Requires PHP 8.2 - honored (update blocked if PHP < 8.2)
- [ ] Requires WordPress 6.5 - honored (update blocked if WP < 6.5)

### 6. Testing Edge Cases

#### Test with Incompatible PHP Version

Temporarily modify `update.json`:
```json
"requires_php": "9.0"
```

Expected: Update should NOT appear (incompatible).

#### Test with Incompatible WP Version

Temporarily modify `update.json`:
```json
"requires": "7.0"
```

Expected: Update should NOT appear (incompatible).

#### Test with Invalid ZIP URL

Temporarily modify `update.json`:
```json
"download_url": "https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.1/nonexistent.zip"
```

Expected: Update appears, but installation fails gracefully with error message.

### 7. Troubleshooting

#### Update not appearing

1. Clear cache: `?robotstxt_clear_update_cache=1`
2. Verify JSON accessible:
   ```bash
   curl https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/raw/branch/main/update.json
   ```
3. Verify version in JSON is greater than installed version
4. Check WordPress debug log for errors
5. Verify plugin is active

#### Download fails

1. Verify release exists on Gitea
2. Verify ZIP file is attached to release
3. Test direct download:
   ```bash
   wget https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.1/robotstxt-hello-1.2.1.zip
   ```
4. Check file permissions on WordPress uploads directory

#### Installation fails

1. Download ZIP manually and verify structure:
   ```bash
   unzip -l robotstxt-hello-1.2.1.zip
   ```
2. Verify ZIP contains `robotstxt-hello/robotstxt-hello.php`
3. Check WordPress PHP error log
4. Try manual installation via Upload Plugin

## Success Criteria

The test is successful when:

1. ✅ v1.2.0 installs correctly
2. ✅ WordPress detects v1.2.1 update automatically
3. ✅ "View details" modal displays correct information
4. ✅ Update installs successfully
5. ✅ Plugin version changes to 1.2.1
6. ✅ No errors during the entire process
7. ✅ All plugin functionality remains working

## Next Steps After Successful Test

Once the updater is validated:

1. **Document the process** for team members
2. **Apply to other ROBOTSTXT plugins** (copy `robotstxt-updater.php` and `bin/`)
3. **Create CI/CD pipeline** for automated releases (optional)
4. **Set up monitoring** for update failures (optional)

## Notes

- The version 1.2.1 is purely for testing - no functional changes
- Cache duration is 6 hours by default (configurable in `robotstxt-updater.php`)
- The updater works independently of WordPress.org
- Multiple plugins can use the same updater system simultaneously

---

**Test Date:** 2026-01-27
**Tester:** ___________________
**Test Site:** ___________________
**Result:** ⬜ Pass  ⬜ Fail
**Notes:** ___________________
