# ROBOTSTXT Generic Updater

Sistema de actualizaciones genérico para plugins de ROBOTSTXT basado en JSON.

## 🚀 Instalación en cualquier plugin

### 1. Copia el archivo updater

Copia `robotstxt-updater.php` a la **raíz** de tu plugin.

### 2. Añade 2 líneas al archivo principal

Al **final** del archivo principal de tu plugin (justo antes del cierre `?>` o al final si no hay cierre), añade:

```php
// Initialize ROBOTSTXT updater (auto-configures from plugin headers).
require_once __DIR__ . '/robotstxt-updater.php';
Robotstxt_Updater::init( __FILE__ );
```

**Eso es todo.** El updater se auto-configura leyendo los headers de tu plugin.

### 3. Asegúrate de tener el header "Gitea Plugin URI"

En el header de tu plugin debe existir **una de estas opciones**:

**Opción A: Formato corto (recomendado)**
```php
/**
 * Plugin Name: Mi Plugin
 * Gitea Plugin URI: ROBOTSTXT/mi-plugin
 */
```

**Opción B: URL completa**
```php
/**
 * Plugin Name: Mi Plugin
 * Gitea Plugin URI: https://git.robotstxt.es/ROBOTSTXT/mi-plugin
 */
```

**Opción C: Solo Plugin URI** (fallback)
```php
/**
 * Plugin Name: Mi Plugin
 * Plugin URI: https://git.robotstxt.es/ROBOTSTXT/mi-plugin
 */
```

El updater construirá automáticamente la URL del JSON:
- Desde **opción A**: `https://git.robotstxt.es/ROBOTSTXT/mi-plugin/raw/branch/main/update.json`
- Desde **opción B/C**: Extrae la base y añade `/raw/branch/main/update.json`

### 4. Crea el archivo `update.json` en la raíz

```json
{
  "name": "Mi Plugin",
  "slug": "mi-plugin",
  "version": "1.0.0",
  "requires": "6.0",
  "tested": "6.7",
  "requires_php": "8.0",
  "homepage": "https://git.robotstxt.es/ROBOTSTXT/mi-plugin",
  "download_url": "https://git.robotstxt.es/ROBOTSTXT/mi-plugin/releases/download/1.0.0/mi-plugin-1.0.0.zip",
  "author": "ROBOTSTXT",
  "description": "Descripción del plugin",
  "changelog": "<ul><li><strong>1.0.0</strong> – Primera versión.</li></ul>"
}
```

## 📦 Publicar una actualización

### Paso 1: Actualiza tu código y versión

```php
// En el archivo principal del plugin
/**
 * Version: 1.2.0
 */
```

### Paso 2: Actualiza `update.json`

```json
{
  "version": "1.2.0",
  "download_url": "https://git.robotstxt.es/ROBOTSTXT/tu-plugin/releases/download/1.2.0/tu-plugin-1.2.0.zip",
  "changelog": "<ul><li><strong>1.2.0</strong> – Nuevas funcionalidades.</li></ul>"
}
```

### Paso 3: Commit y tag

```bash
git add .
git commit -m "Release v1.2.0"
git tag v1.2.0
git push origin main --tags
```

### Paso 4: Verifica que el ZIP sea accesible

```bash
curl -I https://git.robotstxt.es/ROBOTSTXT/tu-plugin/releases/download/1.2.0/tu-plugin-1.2.0.zip
```

Debe devolver `200 OK`.

## 🧪 Testing y desarrollo

### Forzar comprobación de actualizaciones

Añade este parámetro a cualquier URL de admin:

```
/wp-admin/?robotstxt_clear_update_cache=1
```

Esto limpia el caché y fuerza una nueva comprobación inmediata.

### Desde código

```php
do_action( 'robotstxt_updater_clear_cache' );
```

### Caché automático

El sistema cachea las consultas durante **6 horas**. Puedes cambiar este valor editando la línea en `robotstxt-updater.php`:

```php
set_site_transient( $this->cache_key, $remote ?: array(), 6 * HOUR_IN_SECONDS );
```

## ⚠️ Checklist crítico

- [ ] El header "Gitea Plugin URI" está presente
- [ ] El archivo `update.json` existe en la raíz del plugin
- [ ] El archivo `update.json` está commiteado en la rama `main`
- [ ] La URL del JSON es accesible públicamente (sin auth)
- [ ] El ZIP de descarga es accesible públicamente
- [ ] La estructura del ZIP contiene la carpeta raíz con el nombre del slug
- [ ] Las 3 versiones coinciden (header del plugin, JSON, tag de Git)

## 📋 Estructura del ZIP

El ZIP descargable **DEBE** tener esta estructura:

```
mi-plugin-1.2.0.zip
└── mi-plugin/           ← Carpeta con el nombre del slug
    ├── mi-plugin.php    ← Archivo principal
    ├── update.json
    ├── robotstxt-updater.php
    └── ... otros archivos
```

**IMPORTANTE**: La carpeta raíz dentro del ZIP debe llamarse igual que el slug del plugin.

## 🔍 Troubleshooting

### La actualización no aparece

1. Verifica que el JSON sea accesible:
   ```bash
   curl https://git.robotstxt.es/ROBOTSTXT/tu-plugin/raw/branch/main/update.json
   ```

2. Limpia el caché:
   ```
   /wp-admin/?robotstxt_clear_update_cache=1
   ```

3. Verifica que la versión del JSON sea mayor que la instalada

### El ZIP no se descarga

1. Verifica que sea accesible sin autenticación:
   ```bash
   curl -I https://git.robotstxt.es/ROBOTSTXT/tu-plugin/releases/download/1.2.0/tu-plugin-1.2.0.zip
   ```

2. Comprueba que Gitea esté configurado para servir archivos públicamente

### "Fallo en la instalación"

1. Descarga el ZIP manualmente y verifica su estructura
2. La carpeta raíz debe tener el mismo nombre que el slug del plugin
3. El archivo principal debe estar en la raíz de esa carpeta

## 🔧 Personalización avanzada

### Cambiar la rama del JSON

Por defecto usa `main`. Para cambiar a `dev` o `develop`, edita `robotstxt-updater.php`:

```php
return rtrim( $gitea_uri, '/' ) . '/raw/branch/dev/update.json';
```

### Canales (stable/beta)

Puedes crear múltiples JSON:
- `update.json` → stable
- `update-beta.json` → beta

Y cambiar la URL según un filtro o constante.

### Firma/Checksum

Añade al JSON:
```json
{
  "version": "1.2.0",
  "checksum": "sha256:abc123...",
  "download_url": "..."
}
```

Y valida antes de instalar (requiere modificar `robotstxt-updater.php`).

## 📝 Ejemplo completo

Ver el plugin **robotstxt-hello** como referencia de implementación completa.
