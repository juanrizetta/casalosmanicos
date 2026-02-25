# Casa Los Manicos - Sitio Web Estático

Este proyecto contiene una página web moderna y responsiva para un alojamiento turístico, junto con scripts de automatización para su despliegue en un VPS Ubuntu con Nginx.

## 🚀 Inicio Rápido

### 1. Preparación del VPS
Sube el script de inicialización a tu servidor y ejecútalo:
```bash
bash scripts/setup_vps.sh
```
*Este script instalará Nginx, configurará el firewall (UFW) y preparará el directorio raíz en `/var/www/casalosmanicos.com`.*

### 2. Despliegue de la Web
Copia el contenido de la carpeta `public/` al directorio raíz de tu servidor (por defecto `/var/www/casalosmanicos.com`).

### 3. Personalización Fácil
No necesitas editar código HTML complejo. Toda la configuración visual y de texto se encuentra en:
👉 `public/js/config.js`

Edita ese archivo para cambiar:
- Título y eslogan.
- Datos de contacto (Teléfono, Email, Dirección).
- Características y descripciones.

## 📁 Estructura del Proyecto
- `public/`: Archivos de la página web (HTML, CSS, JS, Imágenes).
- `scripts/`: Scripts de administración del sistema.
- `assets/`: Imágenes de alta resolución generadas para el proyecto.

## 🛠️ Operación y Mantenimiento
- **Actualizar Imágenes**: Sustituye los archivos en `public/assets/` manteniendo los nombres o actualiza las rutas en `public/js/config.js`.
- **Seguridad SSL**: Una vez el dominio apunte a la IP del VPS, te recomendamos ejecutar:
  `sudo apt install certbot python3-certbot-nginx && sudo certbot --nginx`
