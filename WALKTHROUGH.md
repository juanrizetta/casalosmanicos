# Walkthrough: Casa Los Manicos Project

He completado el proyecto para la página web de tu alojamiento turístico. Aquí tienes un resumen de lo que hemos construido y cómo ponerlo en marcha.

## 1. Estructura del Proyecto
- `scripts/setup_vps.sh`: Script para configurar tu servidor Ubuntu con Nginx de forma ligera y segura.
- `public/`: Directorio raíz de la web.
    - `index.html`: Estructura principal moderna y responsiva.
    - `css/styles.css`: Diseño premium con efectos de vidrio (glassmorphism) y tipografía cuidada.
    - `js/config.js`: **Aquí es donde puedes cambiar los textos e imágenes fácilmente.**
    - `assets/`: Carpeta con las fotos (he generado unas fotos de ejemplo espectaculares).

## 2. Inicialización del VPS
Para configurar tu VPS, sigue estos pasos:
1. Sube el archivo [setup_vps.sh](scripts/setup_vps.sh) a tu servidor.
2. Ejecuta: `bash scripts/setup_vps.sh`.
3. El script es **idempotente** (puedes ejecutarlo varias veces de forma segura). Instalará Nginx, Certbot para el SSL, configurará el firewall y preparará la carpeta de la web.

## 3. Personalización Fácil
No necesitas editar el código HTML para cambiar lo básico. Abre [config.js](public/js/config.js) y verás una estructura como esta:

```javascript
const CONFIG = {
    title: "Casa Los Manicos",
    tagline: "Tu Refugio Privado",
    contact: {
        address: "Calle Principal 123...",
        // ...
    }
};
```
Simplemente cambia los valores entre comillas y guarda el archivo.

## 4. Diseño Visual
La web incluye:
- **Efecto Glassmorphism**: La cabecera se vuelve translúcida al hacer scroll.
- **Diseño Mobile-First**: Se ve perfecto en móviles y tablets.
- **Imágenes de Alta Calidad**: He incluido placeholders realistas basados en tu descripción.

![Hero Image](public/assets/hero.png)
*Vista previa del diseño Hero*

![Interior](public/assets/interior_1.png)
*Vista previa de los interiores*

### 📹 Demostración Visual
He generado una grabación de la navegación por la página y capturas de las diferentes secciones para que puedas ver el resultado final:

![Navegación Web](/home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/casalosmanicos_preview_1772027483147.webp)
*Grabación de la navegación por el sitio*

````carousel
![Servicios](/home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/servicios_section_1772027503200.png)
<!-- slide -->
![Galería y Contacto](/home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/galeria_and_footer_1772027519381.png)
````

## 5. SSL y Seguridad Automática
El despliegue incluye seguridad completa desde el primer momento:
- **HTTPS Automático**: El script utiliza Certbot para obtener un certificado de Let's Encrypt sin intervención manual (siempre que el dominio ya esté apuntando al servidor).
- **Redirección Forzada**: Toda visita a `http://` será redirigida automáticamente a `https://` para proteger a tus usuarios.
- **Mantenimiento Cero**: Se incluye una tarea programada que renueva el certificado antes de que caduque.

## Próximos Pasos
1. Sube el contenido de la carpeta `public/` a `/var/www/casalosmanicos.com` en tu VPS.
2. Asegúrate de que tu dominio apunta a la IP del VPS.
3. Ejecuta el script de configuración y ¡disfruta de tu nueva web segura!
