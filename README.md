# Casa Los Manicos - Sitio Web Estático

Este proyecto contiene una página web moderna y responsiva para un alojamiento turístico, junto con scripts de automatización para su despliegue en un VPS Ubuntu con Nginx.

## 🚀 Inicio Rápido

### 1. Preparación del VPS
Antes de ejecutar el script, debes configurar tu token de acceso de GitHub (PAT) como variable de entorno:

```bash
export GITHUB_TOKEN='tu_token_aqui'
bash scripts/setup_vps.sh
```
> [!NOTE]
> El script creará automáticamente el usuario **juanri** con permisos de sudo y clonará el repositorio en su carpeta personal.

### 2. Despliegue de la Web
Copia el contenido de la carpeta `public/` al directorio raíz de tu servidor (por defecto `/var/www/casalosmanicos.com`).

## 📁 Estructura del Proyecto y Despliegue
- **Directorio de la App**: `/home/juanri/app/casalosmanicos` (donde vive el código git).
- **Enlace Simbólico**: `/var/www/casalosmanicos.com` apunta directamente a la carpeta `public/` del repo para actualizaciones instantáneas.

## 📁 Estructura del Proyecto
- `public/`: Archivos de la página web (HTML, CSS, JS, Imágenes).
- `scripts/`: Scripts de administración del sistema.
- `assets/`: Imágenes de alta resolución generadas para el proyecto.

## 🔒 Certificado SSL (Automático)
El script `scripts/setup_vps.sh` gestiona la obtención del certificado SSL de forma automática a través de **Let's Encrypt**. 

Para que funcione correctamente:
1. **Configura tu Dominio**: Asegúrate de que el registro A de tu dominio (ej. `casalosmanicos.com`) apunte a la IP de tu VPS.
2. **Ejecuta el Script**: Al ejecutar `bash scripts/setup_vps.sh`, el sistema detectará el dominio, instalará Certbot y solicitará el certificado.
3. **Renovación**: El script también deja configurada la renovación automática para que no tengas que preocuparte por el vencimiento.

## 🛠️ Operación y Mantenimiento
- **Idempotencia**: Puedes ejecutar el script de inicialización múltiples veces de forma segura; solo aplicará los cambios que falten.
- **Actualizar Imágenes**: Sustituye los archivos en `public/assets/` manteniendo los nombres o actualiza las rutas en `js/config.js`.
