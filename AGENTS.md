# Development Guidelines

These rules apply to the entire repository.

## Platform Compatibility

* WordPress core: **6.5 → 6.9**
* PHP: **8.2 → 8.5** (use modern syntax; never drop the minimum version declared in the plugin header)

## Language

* All documentation, copy, comments, and code annotations must be written in **American English**.

## Code Standards

* All PHP must follow **PHPCS** and **WordPress Coding Standards (WPCS)** without exceptions.
* **Tabs** are required for indentation in PHP files.
* All code must remain fully compatible with **PHP 8.2+** and follow modern best practices.
* Provide complete **PHPDoc** for:
  * Classes, interfaces, traits
  * Functions and methods
  * Hook callbacks
  * All properties
* Security requirements:
  * Sanitize, validate, and escape all external input.
  * Use WordPress nonces in every form or action handler.
  * Never suppress validation or authentication failures.

## WordPress Security

* Sanitize, validate, and escape **all** user-supplied data.
* Add and verify nonces for any form or request that performs actions.
* Do not hide or suppress errors related to validation or permissions.

## Plugin Structure

* Keep functional code modular under **`includes/`**.
* Place admin-specific logic inside **`includes/admin/`** subdirectories.
* Store all UI templates in **`templates/`**.
* When introducing persistent data (options, tables, user meta, etc.):
  * Update **`uninstall.php`** to remove all related data on uninstall.

## Testing and Tooling

* Run all automated checks before submitting work:
  * **PHPCS**
  * **PHPUnit**
  * Any additional project-specific tooling
* Create and maintain unit tests for every practical piece of functionality.
* After running checks, provide a brief summary of executed commands and their outcomes.

## Documentation

* Update **`readme.txt`** and **`changelog.txt`** for any functional change.
* Add explanatory comments when intent is not immediately obvious.

## Internationalization (i18n)

* Ensure the plugin follows all WordPress i18n rules:
  * Correct use of translation functions (`__()`, `_e()`, `_x()`, etc.)
  * Proper text-domain loading
  * Up-to-date translation templates
* Maintain translation files for the following locales:
  * Catalan (`ca`)
  * German (`de_DE`)
  * Spanish (`es_ES`)
  * Basque (`eu`)
  * French (`fr_FR`)
  * Galician (`gl_ES`)
  * Italian (`it_IT`)
  * Polish (`pl_PL`)
  * Portuguese (`pt_PT`)
