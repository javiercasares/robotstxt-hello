# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.1] - 2026-01-27

### Changed
- Test release to validate the Auto-Updater system is working correctly
- No functional changes from v1.2.0

## [1.2.0] - 2026-01-27

### Added
- Generic JSON-based Auto-Updater system
- Plugin now updates automatically from git.robotstxt.es
- Independent update system without depending on WordPress.org repository
- `robotstxt-updater.php` - Reusable updater for all ROBOTSTXT plugins
- `update.json` - Update manifest with version and download information
- Comprehensive updater documentation (UPDATER-README.md, UPDATER-TEMPLATE.txt)

### Changed
- Updated plugin architecture to support automatic updates

## [1.1.2] - 2025-01-XX

### Changed
- Raised minimum WordPress requirement to 6.5
- Raised minimum PHP requirement to 8.2
- Updated to comply with AGENTS development guidelines

## [1.1.1] - 2024-XX-XX

### Added
- Compiled translation catalogs for supported locales
  - Catalan (ca)
  - German (de_DE)
  - Spanish (es_ES)
  - Basque (eu)
  - French (fr_FR)
  - Galician (gl_ES)
  - Italian (it_IT)
  - Polish (pl_PL)
  - Portuguese (pt_PT)

### Changed
- Localized greetings now render without requiring manual compilation

## [1.1.0] - 2024-XX-XX

### Added
- DID (Decentralized Identifier) Support
- Plugin ID: `did:plc:7umwjtio3qenfqiai2m5gsgg`

## [1.0.5] - 2024-XX-XX

### Added
- Expanded translation catalog to cover 202 locales
- Updated greetings for all supported locales

## [1.0.4] - 2024-XX-XX

### Added
- PHPDoc blocks for plugin internals documentation
- Loaded text domain to ensure translations are available in WordPress

## [1.0.3] - 2024-XX-XX

### Added
- Translation files for 50 locales
- Improved WordPress i18n coverage

## [1.0.2] - 2024-XX-XX

### Changed
- Confirmed compatibility with PHP 5.6 through PHP 8.4
- Added PHPCompatibilityWP checks

## [1.0.1] - 2024-XX-XX

### Changed
- Broadened compatibility to cover WordPress 4.7+
- Broadened compatibility to cover PHP 5.6+
- Hello admin page unchanged

## [1.0.0] - 2024-XX-XX

### Added
- Initial release
- Hello admin page
- Admin menu entry

---

[1.2.1]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.2.1
[1.2.0]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.2.0
[1.1.2]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.1.2
[1.1.1]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.1.1
[1.1.0]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.1.0
[1.0.5]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.0.5
[1.0.4]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.0.4
[1.0.3]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.0.3
[1.0.2]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.0.2
[1.0.1]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.0.1
[1.0.0]: https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/tag/v1.0.0
