# WordPress FAIR Compatibility Plugin Guidelines

This repository contains a reference WordPress plugin that demonstrates the minimal structure required to be interoperable with
FAIR tools.

## Functional Scope
- The plugin must register a single top-level admin menu labeled **Hello**.
- The admin page rendered by the menu should display only the page title "Hello" and no additional content.
- The plugin is intentionally lightweight and serves purely as an integration example.

## Coding Standards & Security
- Follow PHP_CodeSniffer (PHPCS) and WordPress Coding Standards (WPCS) rigorously across all PHP sources.
- Ensure every change complies with PHP 8.2+ syntax and best practices; do not decrease the minimum supported version advertised
 in the plugin header.
- Security is paramount: sanitize, validate, and escape all data appropriately, and include WordPress nonces in every form or ac
tion handler.
- Write comprehensive PHPDoc blocks for all classes, methods, functions, and hooks.
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
  1. Inglés (`en`)
  2. Mandarín chino (`zh`)
  3. Hindi (`hi`)
  4. Español (`es`)
  5. Francés (`fr`)
  6. Árabe estándar (`ar`)
  7. Bengalí (`bn`)
  8. Portugués (`pt`)
  9. Ruso (`ru`)
  10. Urdu (`ur`)
  11. Indonesio (`id`)
  12. Alemán (`de`)
  13. Japonés (`ja`)
  14. Suajili (`sw`)
  15. Maratí (`mr`)
  16. Telugú (`te`)
  17. Turco (`tr`)
  18. Tamil (`ta`)
  19. Vietnamita (`vi`)
  20. Coreano (`ko`)
  21. Italiano (`it`)
  22. Hausá (`ha`)
  23. Tailandés (`th`)
  24. Persa (`fa`)
  25. Polaco (`pl`)
  26. Ucraniano (`uk`)
  27. Malayo (`ms`)
  28. Canarés (`kn`)
  29. Chino Wu (Shanghainés) (`wuu`)
  30. Chino Yue (Cantonés) (`yue`)
  31. Birmano (`my`)
  32. Javanés (`jv`)
  33. Filipino (Tagalo) (`tl`)
  34. Punyabí (`pa`)
  35. Romaní (`rom`)
  36. Guzerati (`gu`)
  37. Bhojpuri (`bho`)
  38. Malabar (Malayalam) (`ml`)
  39. Oromanés (`om`)
  40. Sindhi (`sd`)
  41. Neerlandés (Holandés) (`nl`)
  42. Kurdo Kurmanji (`ku`)
  43. Checo (`cs`)
  44. Sueco (`sv`)
  45. Húngaro (`hu`)
  46. Hebreo (`he`)
  47. Griego (`el`)
  48. Finés (`fi`)
  49. Danés (`da`)
  50. Noruego (`no`)

## Documentation Practices
- Maintain thorough documentation in U.S. English across code comments and Markdown files.
- Record every significant change both in `changelog.txt` and `readme.txt`, ensuring the entries stay synchronized.

Adhering to these guidelines keeps the example plugin consistent, secure, and easy to understand.
