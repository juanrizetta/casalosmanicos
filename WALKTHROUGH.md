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
2. Ejecuta: `bash setup_vps.sh`.
3. El script instalará Nginx, configurará el firewall y preparará la carpeta `/var/www/casalosmanicos.com`.

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

## Próximos Pasos
1. Sube el contenido de la carpeta `public/` a `/var/www/casalosmanicos.com` en tu VPS.
2. Asegúrate de que tu dominio apunta a la IP del VPS.
3. ¡Disfruta de tu nueva web!
