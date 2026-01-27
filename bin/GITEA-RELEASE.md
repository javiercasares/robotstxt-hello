# Cómo Crear un Release en Gitea

Guía paso a paso para publicar un release en Gitea con el ZIP del plugin.

## Prerequisitos

1. Has ejecutado `./bin/release.sh 1.2.0` (o los scripts manualmente)
2. El tag `v1.2.0` existe en el repositorio remoto
3. Tienes el ZIP generado: `robotstxt-hello-1.2.0.zip`

## Pasos en Gitea

### 1. Ir a la Página de Releases

Navega a:
```
https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases
```

O desde el repositorio:
- Click en **"Releases"** en el menú lateral

### 2. Crear Nuevo Release

Click en el botón **"New Release"** (o "Nuevo Release")

### 3. Configurar el Release

**Tag:**
- Selecciona el tag existente: `v1.2.0`
- O crea uno nuevo si no existe

**Release Title:**
```
v1.2.0
```

**Release Description:**

Copia el contenido de `changelog.txt` para esta versión:

```
Added generic JSON-based Auto-Updater system. Plugin now updates automatically from git.robotstxt.es without depending on WordPress.org repository.
```

O en formato Markdown:

```markdown
## What's New in v1.2.0

### Added
- Generic JSON-based Auto-Updater system
- Plugin now updates automatically from git.robotstxt.es
- Independent update system without depending on WordPress.org repository

### Technical Details
- `robotstxt-updater.php` - Reusable updater for all ROBOTSTXT plugins
- `update.json` - Update manifest with version and download information
- Comprehensive updater documentation

### Installation
Download and install through WordPress Admin → Plugins → Add New → Upload Plugin
```

### 4. Adjuntar el ZIP

**Importante:** Debes subir el ZIP con el **nombre exacto** que espera `update.json`:

- Click en **"Attach files"** o **"Adjuntar archivos"**
- Selecciona: `robotstxt-hello-1.2.0.zip`
- **NO cambies el nombre del archivo**

El archivo debe llamarse exactamente:
```
robotstxt-hello-1.2.0.zip
```

Para que coincida con:
```json
"download_url": "https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.0/robotstxt-hello-1.2.0.zip"
```

### 5. Opciones Adicionales

- **Pre-release:** Deja sin marcar (a menos que sea una versión beta/rc)
- **Set as latest release:** Marca esta opción

### 6. Publicar

Click en **"Publish Release"** o **"Publicar Release"**

## Verificación

### Verificar que el ZIP es accesible

```bash
curl -I https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.0/robotstxt-hello-1.2.0.zip
```

Debe devolver:
```
HTTP/2 200
content-type: application/zip
```

### Verificar el tamaño

```bash
curl -sI https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.0/robotstxt-hello-1.2.0.zip | grep -i content-length
```

Debe mostrar aproximadamente 29KB para robotstxt-hello v1.2.0.

### Descargar y probar

```bash
# Descargar
wget https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases/download/1.2.0/robotstxt-hello-1.2.0.zip

# Verificar contenido
unzip -l robotstxt-hello-1.2.0.zip
```

## Probar el Auto-Updater

1. **Instala una versión anterior** en un WordPress de prueba (ej. v1.1.2)

2. **Fuerza la comprobación de actualizaciones:**
   ```
   https://tu-wp.com/wp-admin/?robotstxt_clear_update_cache=1
   ```

3. **Ve a Plugins → Actualizaciones disponibles**
   - Deberías ver "Hello (by ROBOTSTXT)" con "Actualización disponible"
   - Versión nueva: 1.2.0

4. **Click en "Ver detalles"**
   - Se abre un modal con el changelog
   - Verifica que muestra la información correcta

5. **Click en "Actualizar ahora"**
   - WordPress descarga desde Gitea
   - Instala la nueva versión
   - Plugin se actualiza correctamente

6. **Verifica la versión instalada:**
   - En Plugins debería mostrar "Versión 1.2.0"
   - En el código: busca `Version: 1.2.0` en el header

## Troubleshooting

### Error 404 al descargar

**Problema:** `curl` devuelve 404

**Solución:**
1. Verifica que el release existe: `https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/releases`
2. Verifica que el archivo está adjunto al release
3. Verifica el nombre exacto del archivo (debe coincidir con update.json)

### Nombre de archivo incorrecto

**Problema:** Subiste el ZIP con otro nombre

**Solución:**
1. Elimina el release
2. Vuelve a crear con el nombre correcto: `robotstxt-hello-1.2.0.zip`

O edita el release y sube el archivo con el nombre correcto.

### WordPress no detecta la actualización

**Problema:** El plugin no muestra actualización disponible

**Solución:**
1. Fuerza limpieza de caché: `?robotstxt_clear_update_cache=1`
2. Verifica que `update.json` es accesible:
   ```bash
   curl https://git.robotstxt.es/ROBOTSTXT/robotstxt-hello/raw/branch/main/update.json
   ```
3. Verifica que la versión en `update.json` es mayor que la instalada

### Error al instalar actualización

**Problema:** WordPress muestra "Error al instalar actualización"

**Causas posibles:**
1. ZIP corrupto o incompleto
2. Estructura del ZIP incorrecta
3. Permisos en el servidor

**Solución:**
1. Descarga el ZIP manualmente y verifica con `unzip -l`
2. Verifica que la estructura es:
   ```
   robotstxt-hello-1.2.0.zip
   └── robotstxt-hello/
       ├── robotstxt-hello.php
       └── ...
   ```
3. Prueba instalación manual desde WordPress Admin

## Automatización Futura

Para automatizar la subida del ZIP a Gitea, puedes usar:

- **Gitea API:** Crear release via API
- **GitHub Actions / Gitea Actions:** CI/CD pipeline
- **Scripts con `curl`:** POST multipart/form-data

Ejemplo básico con curl (requiere token de API):

```bash
# Crear release
curl -X POST \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "tag_name": "v1.2.0",
    "name": "v1.2.0",
    "body": "Release notes..."
  }' \
  https://git.robotstxt.es/api/v1/repos/ROBOTSTXT/robotstxt-hello/releases

# Subir asset al release
curl -X POST \
  -H "Authorization: token YOUR_TOKEN" \
  -F "attachment=@robotstxt-hello-1.2.0.zip" \
  https://git.robotstxt.es/api/v1/repos/ROBOTSTXT/robotstxt-hello/releases/RELEASE_ID/assets
```

---

**Nota:** Esta guía asume Gitea v1.17+. Algunos pasos pueden variar en versiones anteriores.
