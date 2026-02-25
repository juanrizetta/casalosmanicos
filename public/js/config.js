// Casa Los Manicos - Configuration File
// Edit the values below to change the website content easily.

const CONFIG = {
    title: "Casa Los Manicos",
    tagline: "Tu Refugio Privado",
    description: "Descubre la combinación perfecta de lujo, confort y naturaleza en un espacio diseñado para tu descanso.",

    // Contact Information
    contact: {
        address: "Calle Luengo Bajo 20, Moratalla, Murcia",
        phone: "+34 600 000 000",
        email: "casalosmanicos@gmail.es"
    },

    // Services / Features
    features: [
        {
            title: "Diseño Moderno",
            text: "Espacios abiertos, luz natural y mobiliario de alta calidad para una experiencia premium.",
            image: "assets/interior_1.png"
        },
        {
            title: "Ubicación Prime",
            text: "Situada en un entorno tranquilo pero cerca de todos los puntos de interés locales.",
            image: "assets/exterior_1.png"
        },
        {
            title: "Full Equipada",
            text: "Cocina completa, WiFi de alta velocidad, aire acondicionado y todo lo necesario.",
            image: "assets/room_1.png"
        }
    ]
};

// This function will automatically apply the changes to the page
document.addEventListener('DOMContentLoaded', () => {
    // Update basic text
    document.title = `${CONFIG.title} | Alojamiento Turístico Único`;
    document.querySelector('.logo').innerText = CONFIG.title.toUpperCase();
    document.querySelector('.hero-content h1').innerText = CONFIG.tagline;
    document.querySelector('.hero-content p').innerText = CONFIG.description;

    // Update contact info
    const contactSection = document.getElementById('contacto');
    if (contactSection) {
        contactSection.querySelector('p:nth-of-type(2)').innerHTML = `📍 ${CONFIG.contact.address}`;
        contactSection.querySelector('p:nth-of-type(3)').innerHTML = `📞 ${CONFIG.contact.phone}`;
        contactSection.querySelector('p:nth-of-type(4)').innerHTML = `✉️ ${CONFIG.contact.email}`;
    }
});
