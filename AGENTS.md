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
- Provide comprehensive PHPDoc blocks for every class, interface, trait, function, method, hook callback, and property within the plugin.
- Use tabs—not spaces—for indentation in PHP files to align with WPCS expectations.
- Create unit tests for every feasible piece of functionality and keep them up to date with any change.
- Execute the full automated test suite (or as much as is technically possible) before delivering any work.

## Platform Compatibility
- Maintain compatibility with WordPress core versions 4.7 through 6.9.
- Support PHP versions 5.6 through 8.4 while prioritizing modern best practices.

## Internationalization Requirements
- Ensure the plugin remains fully compatible with WordPress internationalization (i18n) mechanisms, including proper loading of text domains and translation files.
- Create and maintain translation files for all supported locales, keeping them synchronized with the source strings.
- Required translation files:
  1. English (`en`)
  2. Mandarin Chinese (`zh`)
  3. Hindi (`hi`)
  4. Spanish (`es`)
  5. French (`fr`)
  6. Standard Arabic (`ar`)
  7. Bengali (`bn`)
  8. Portuguese (`pt`)
  9. Russian (`ru`)
  10. Urdu (`ur`)
  11. Indonesian (`id`)
  12. German (`de`)
  13. Japanese (`ja`)
  14. Swahili (`sw`)
  15. Marathi (`mr`)
  16. Telugu (`te`)
  17. Turkish (`tr`)
  18. Tamil (`ta`)
  19. Vietnamese (`vi`)
  20. Korean (`ko`)
  21. Italian (`it`)
  22. Hausa (`ha`)
  23. Thai (`th`)
  24. Persian (Farsi) (`fa`)
  25. Polish (`pl`)
  26. Ukrainian (`uk`)
  27. Malay (`ms`)
  28. Kannada (`kn`)
  29. Wu Chinese (Shanghainese) (`wuu`)
  30. Yue Chinese (Cantonese) (`yue`)
  31. Burmese (`my`)
  32. Javanese (`jv`)
  33. Filipino (Tagalog) (`tl`)
  34. Punjabi (`pa`)
  35. Romani (`rom`)
  36. Gujarati (`gu`)
  37. Bhojpuri (`bho`)
  38. Malayalam (`ml`)
  39. Oromo (`om`)
  40. Sindhi (`sd`)
  41. Dutch (`nl`)
  42. Kurdish Kurmanji (`ku`)
  43. Czech (`cs`)
  44. Swedish (`sv`)
  45. Hungarian (`hu`)
  46. Hebrew (`he`)
  47. Greek (`el`)
  48. Finnish (`fi`)
  49. Danish (`da`)
  50. Norwegian (`no`)

## Documentation Practices
- Maintain thorough documentation in U.S. English across code comments and Markdown files.
- Record every significant change both in `changelog.txt` and `readme.txt`, ensuring the entries stay synchronized.

Adhering to these guidelines keeps the example plugin consistent, secure, and easy to understand.
