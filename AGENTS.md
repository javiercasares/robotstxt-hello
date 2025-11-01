# WordPress FAIR Compatibility Plugin Guidelines

This repository contains a reference WordPress plugin that demonstrates the minimal structure required to be interoperable with FAIR tools.

## Functional Scope
- The plugin must register a single top-level admin menu labeled **Hello**.
- The admin page rendered by the menu should display only the page title "Hello" and no additional content.
- The plugin is intentionally lightweight and serves purely as an integration example.

## Coding Standards & Security
- Follow PHP_CodeSniffer (PHPCS) and WordPress Coding Standards (WPCS) rigorously across all PHP sources.
- Ensure every change complies with PHP 8.2+ syntax and best practices; do not decrease the minimum supported version advertised in the plugin header.
- Security is paramount: sanitize, validate, and escape all data appropriately, and include WordPress nonces in every form or action handler.
- Write comprehensive PHPDoc blocks for all classes, methods, functions, and hooks.
- Use tabs—not spaces—for indentation in PHP files to align with WPCS expectations.
- Create unit tests for every feasible piece of functionality and keep them up to date with any change.
- Execute the full automated test suite (or as much as is technically possible) before delivering any work.

## Platform Compatibility
- Maintain compatibility with WordPress core versions 4.7 through 6.9.
- Support PHP versions 5.6 through 8.4 while prioritizing modern best practices.

## Documentation Practices
- Maintain thorough documentation in U.S. English across code comments and Markdown files.
- Record every significant change both in `changelog.txt` and `readme.txt`, ensuring the entries stay synchronized.

Adhering to these guidelines keeps the example plugin consistent, secure, and easy to understand.
