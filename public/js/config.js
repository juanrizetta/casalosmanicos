// Casa Los Manicos - Configuration File
// Edit the values below to change the website content easily.

const CONFIG = {
    title: "Casa Rural Los Manicos",
    tagline: "Tu Refugio en Moratalla",
    description: "Descubre la combinación perfecta de lujo, confort y naturaleza en un espacio diseñado para tu descanso.",

    // Contact Information
    contact: {
        address: "Calle Luengo Bajo 20, Moratalla, Murcia",
        phone: "+34 600 000 000",
        email: "casalosmanicos@gmail.es"
    },

    // Services / Features (Carousels)
    sections: [
        {
            id: "servicios-interior",
            title: "Interiores de Ensueño",
            text: "Espacios abiertos, luz natural y mobiliario de alta calidad para una estancia de lujo.",
            images: [
                "assets/interior_1.png",
                "assets/interior_2.png",
                "assets/interior_3.png"
            ]
        },
        {
            id: "servicios-exterior",
            title: "Entorno Privado",
            text: "Un entorno idilico, donde disfrutar de la naturaleza y la tranquilidad.",
            images: [
                "assets/exterior_1.png",
                "assets/exterior_2.png",
                "assets/exterior_3.png"
            ]
        },
        {
            id: "servicios-habitaciones",
            title: "Descanso Absoluto",
            text: "Habitaciones diseñadas para el confort máximo con ropa de cama premium y silencio total.",
            images: [
                "assets/room_1.png",
                "assets/room_2.png",
                "assets/room_3.png"
            ]
        }
    ],

    // Pricing Information
    pricing: {
        title: "Tarifas y Disponibilidad",
        description: "Precios por noche diseñados para adaptarse a tu grupo. Estancia mínima: 2 noches.",
        seasons: [
            {
                name: "Temporada Baja",
                ranges: [
                    { persons: "1 - 4 personas", price: "120€" },
                    { persons: "5 - 6 personas", price: "150€" },
                    { persons: "Persona extra (hasta 8)", price: "15€" }
                ]
            },
            {
                name: "Temporada Alta",
                ranges: [
                    { persons: "1 - 4 personas", price: "150€" },
                    { persons: "5 - 6 personas", price: "180€" },
                    { persons: "Persona extra (hasta 8)", price: "20€" }
                ]
            }
        ]
    }
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
