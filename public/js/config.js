// Casa Los Manicos - Configuration File
// Edit the values below to change the website content easily.

const CONFIG = {
    title: "Casa Rural Los Manicos",
    tagline: "Tu Refugio en Moratalla",
    description: "Encanto rural y confort en el centro histórico. El descanso que buscas, a un paso del Castillo. Ideal para 6 personas, maximo 8",

    // Contact Information
    contact: {
        address: "Calle Luengo Bajo 20, Moratalla, Murcia",
        phone: "+34 711218967",
        email: "casalosmanicos@gmail.com",
        formspreeId: "xpqjggej"
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
        description: "Precios por noche diseñados para adaptarse a tu grupo. Estancia mínima: 2 noches. Temporada Alta: Julio, Agosto, Semana Santa, Nochevieja, Nochebuena y Puentes completos",
        seasons: [
            {
                name: "Temporada Baja",
                ranges: [
                    { persons: "De 1 a 4 personas", price: "120€" },
                    { persons: "De 5 a 6 personas", price: "150€" },
                    { persons: "De 7 a 8 personas", price: "170€" }
                ]
            },
            {
                name: "Temporada Alta",
                ranges: [
                    { persons: "De 1 a 4 personas", price: "150€" },
                    { persons: "De 5 a 6 personas", price: "180€" },
                    { persons: "De 7 a 8 personas", price: "210€" }
                ]
            }
        ]
    },

    // Google Calendar Integration
    // You will need to provide your Google Calendar ID and an API Key.
    calendar: {
        show: false,
        googleCalendarId: "casalosmanicos@gmail.com",
        apiKey: "AIzaSyCEzPYhNG1F5wGcyhhUzPiL5OGT3ghUR40"
    }
};
