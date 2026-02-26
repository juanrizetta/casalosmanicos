# Walkthrough: Casa Rural Los Manicos

Este documento detalla el funcionamiento, la estructura y las características de la nueva web para el alojamiento turístico "Casa Rural Los Manicos".

## 1. Estructura del Proyecto
- `public/`: Contiene los archivos de la web (HTML, CSS y JS).
- `public/assets/`: Imágenes de alta calidad (habitaciones, exteriores, etc.).
- `public/js/config.js`: **Archivo clave** donde se gestiona todo el contenido.
- `scripts/setup_vps.sh`: Script de automatización para tu servidor Ubuntu.

## 2. Inicialización del VPS
Para configurar tu VPS, sigue estos pasos:
1. Sube el archivo [setup_vps.sh](scripts/setup_vps.sh) a tu servidor.
2. Exporta tu token: `export GITHUB_TOKEN='tu_token'`.
3. Ejecuta: `bash scripts/setup_vps.sh`.
4. El script creará el usuario **juanri**, configurará Git para sincronizar el repo mediante el token y creará un **enlace simbólico** de la web. De esta forma, cada vez que hagas un `git pull` en el servidor, la web se actualizará automáticamente.

## 3. Personalización Fácil (config.js)
No necesitas editar el código HTML para cambiar lo básico. Abre [config.js](public/js/config.js) y verás una estructura como esta:
```javascript
const CONFIG = {
    title: "Casa Rural Los Manicos",
    tagline: "Tu Refugio en Moratalla",
    // ...
}
```
Simplemente cambia los valores entre comillas y guarda el archivo.

## 4. Gestión de Precios Dinámicos
Hemos sustituido la sección de galería estática por una **Sección de Precios** dinámica que se alimenta íntegramente de [config.js](public/js/config.js).
- **Temporadas**: Soporta configuración de Temporada Baja y Alta.
- **Flexibilidad**: Los precios se ajustan automáticamente según el número de personas, incluyendo el coste por persona extra.
- **Diseño**: Las tablas tienen un diseño moderno con efectos de glassmorphism.

### Vista de las Tarifas
![Sección de Precios configurada](file:///home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/precios_section_1772047974038.png)

## 5. Caruseles de Imágenes
Hemos implementado carruseles dinámicos en la sección "Nuestra Propuesta".
- **Interacción**: Los carruseles cambian de imagen automáticamente cada 5-7 segundos.
- **Control Manual**: El usuario puede usar las flechas laterales o los puntos indicadores.

### Vista Previa de los Carruseles
![Carruseles en la sección Nuestra Propuesta](file:///home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/nuestra_propuesta_carousels_1772046091329.png)

### Video de Funcionamiento
![Video de demostración de carruseles](file:///home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/casalosmanicos_carousels_previewheader_1772045991934.webp)

## 6. SSL Automático y Seguridad
El script [setup_vps.sh](scripts/setup_vps.sh) incluye la automatización de **Let's Encrypt**:
- **HTTPS**: Configura automáticamente el servidor para usar TLS.
- **Redirección**: Fuerza todo el tráfico a HTTPS de forma segura.
- **Idempotencia**: Solo solicita el certificado si no existe o si le quedan menos de 30 días de validez.

## 7. Sincronización con Google Calendar
Hemos añadido un calendario de disponibilidad profesional que se sincroniza en tiempo real con tu cuenta de Google.
- **Gestión Centralizada**: Solo tienes que marcar las fechas ocupadas en tu Google Calendar personal.
- **Detección Automática**: La web detecta si falta la configuración y muestra un aviso amigable.
- **Diseño**: Integrado con el estilo premium y responsive de la web.

### Captura del Calendario
![Calendario de disponibilidad](file:///home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/calendar_section_view_1772056504591.png)

### Video de Verificación (Fallback)
![Demostración de carga y aviso de configuración](file:///home/juanri/.gemini/antigravity/brain/b18035ff-8eeb-4dcb-b481-bd5d59d902e4/casalosmanicos_calendar_debugheader_1772054515124.webp)

## 8. Próximos Pasos
1. **Configura tu Calendario**: Abre [config.js](public/js/config.js) e introduce tu `googleCalendarId` y tu `apiKey`.
2. **Sincronización**: Realiza un `git pull` en tu VPS para recibir estos cambios.
3. **Imágenes Reales**: Sustituye los placeholders en `public/assets/` con tus fotos definitivas (especialmente `hero.png`).
4. **Despliegue**: Asegúrate de que el dominio apunta a la IP y ejecuta el script de configuración.
