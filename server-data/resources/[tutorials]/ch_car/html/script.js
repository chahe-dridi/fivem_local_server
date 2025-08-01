// Enhanced Car Menu JavaScript - Modern Implementation
let selectedCar = null;
let selectedStyle = 'default';
let selectedTarget = 'self';
let currentCategory = 'sports';
let updateInterval = null;
let searchTimeout = null;

// Enhanced vehicle database with additional metadata
const carDatabase = {
    sports: [
        { model: 'adder', name: 'Adder', description: 'High-end supercar', icon: '🏎️', stats: { speed: 95, handling: 85, acceleration: 90 } },
        { model: 'carbonizzare', name: 'Carbonizzare', description: 'Sports coupe', icon: '🚗', stats: { speed: 88, handling: 92, acceleration: 85 } },
        { model: 'comet2', name: 'Comet', description: 'Classic sports car', icon: '🏎️', stats: { speed: 86, handling: 88, acceleration: 82 } },
        { model: 'coquette', name: 'Coquette', description: 'American sports car', icon: '🚗', stats: { speed: 84, handling: 86, acceleration: 80 } },
        { model: 'feltzer2', name: 'Feltzer', description: 'Luxury sports car', icon: '🏎️', stats: { speed: 87, handling: 89, acceleration: 83 } },
        { model: 'rapidgt', name: 'Rapid GT', description: 'Grand tourer', icon: '🚗', stats: { speed: 85, handling: 87, acceleration: 81 } },
        { model: 'surano', name: 'Surano', description: 'Sleek sports car', icon: '🏎️', stats: { speed: 83, handling: 85, acceleration: 79 } },
        { model: 'banshee', name: 'Banshee', description: 'Classic muscle sports', icon: '🚗', stats: { speed: 82, handling: 84, acceleration: 88 } },
        { model: 'elegy2', name: 'Elegy RH8', description: 'Tuner favorite', icon: '🏎️', stats: { speed: 81, handling: 90, acceleration: 78 } },
        { model: 'ninef', name: 'Nine F', description: 'Audi R8 style', icon: '🚗', stats: { speed: 89, handling: 86, acceleration: 84 } }
    ],
    super: [
        { model: 'entityxf', name: 'Entity XF', description: 'Ultimate supercar', icon: '🚀', stats: { speed: 98, handling: 88, acceleration: 95 } },
        { model: 'infernus', name: 'Infernus', description: 'Legendary supercar', icon: '🚀', stats: { speed: 96, handling: 86, acceleration: 93 } },
        { model: 'vacca', name: 'Vacca', description: 'Italian supercar', icon: '🚀', stats: { speed: 94, handling: 84, acceleration: 91 } },
        { model: 'zentorno', name: 'Zentorno', description: 'Modern hypercar', icon: '🚀', stats: { speed: 97, handling: 87, acceleration: 94 } },
        { model: 'turismor', name: 'Turismo R', description: 'Race-bred supercar', icon: '🚀', stats: { speed: 95, handling: 89, acceleration: 92 } },
        { model: 'osiris', name: 'Osiris', description: 'Luxury hypercar', icon: '🚀', stats: { speed: 96, handling: 90, acceleration: 93 } },
        { model: 't20', name: 'T20', description: 'Track-focused supercar', icon: '🚀', stats: { speed: 99, handling: 92, acceleration: 96 } },
        { model: 'reaper', name: 'Reaper', description: 'Aggressive supercar', icon: '🚀', stats: { speed: 94, handling: 85, acceleration: 90 } },
        { model: 'cheetah', name: 'Cheetah', description: 'Fast supercar', icon: '🚀', stats: { speed: 92, handling: 83, acceleration: 89 } },
        { model: 'bullet', name: 'Bullet', description: 'Ford GT style', icon: '🚀', stats: { speed: 91, handling: 82, acceleration: 88 } }
    ],
    muscle: [
        { model: 'dominator', name: 'Dominator', description: 'Classic muscle car', icon: '💪', stats: { speed: 78, handling: 70, acceleration: 92 } },
        { model: 'gauntlet', name: 'Gauntlet', description: 'Retro muscle car', icon: '💪', stats: { speed: 76, handling: 68, acceleration: 90 } },
        { model: 'phoenix', name: 'Phoenix', description: 'Street muscle car', icon: '💪', stats: { speed: 74, handling: 66, acceleration: 88 } },
        { model: 'ruiner', name: 'Ruiner', description: 'Vintage muscle car', icon: '💪', stats: { speed: 72, handling: 64, acceleration: 86 } },
        { model: 'sabregt', name: 'Sabre GT', description: 'Tuned muscle car', icon: '💪', stats: { speed: 75, handling: 67, acceleration: 89 } },
        { model: 'vigero', name: 'Vigero', description: 'Modern muscle car', icon: '💪', stats: { speed: 77, handling: 69, acceleration: 91 } },
        { model: 'blade', name: 'Blade', description: 'Custom muscle car', icon: '💪', stats: { speed: 73, handling: 65, acceleration: 87 } },
        { model: 'dukes', name: 'Dukes', description: 'Classic American muscle', icon: '💪', stats: { speed: 79, handling: 71, acceleration: 93 } },
        { model: 'hotknife', name: 'Hot Knife', description: 'Hot rod', icon: '💪', stats: { speed: 70, handling: 60, acceleration: 95 } },
        { model: 'ratloader', name: 'Rat Loader', description: 'Rat rod pickup', icon: '💪', stats: { speed: 68, handling: 58, acceleration: 85 } }
    ],
    suvs: [
        { model: 'baller', name: 'Baller', description: 'Luxury SUV', icon: '🚙', stats: { speed: 65, handling: 75, acceleration: 70 } },
        { model: 'cavalcade', name: 'Cavalcade', description: 'Large SUV', icon: '🚙', stats: { speed: 63, handling: 73, acceleration: 68 } },
        { model: 'fq2', name: 'FQ 2', description: 'Compact SUV', icon: '🚙', stats: { speed: 67, handling: 77, acceleration: 72 } },
        { model: 'granger', name: 'Granger', description: 'Full-size SUV', icon: '🚙', stats: { speed: 62, handling: 72, acceleration: 67 } },
        { model: 'huntley', name: 'Huntley S', description: 'Premium SUV', icon: '🚙', stats: { speed: 66, handling: 76, acceleration: 71 } },
        { model: 'landstalker', name: 'Landstalker', description: 'Off-road SUV', icon: '🚙', stats: { speed: 64, handling: 78, acceleration: 69 } },
        { model: 'mesa', name: 'Mesa', description: 'Rugged SUV', icon: '🚙', stats: { speed: 68, handling: 80, acceleration: 73 } },
        { model: 'seminole', name: 'Seminole', description: 'Compact SUV', icon: '🚙', stats: { speed: 69, handling: 79, acceleration: 74 } },
        { model: 'patriot', name: 'Patriot', description: 'Military-style SUV', icon: '🚙', stats: { speed: 61, handling: 82, acceleration: 66 } },
        { model: 'radius', name: 'Radius', description: 'Family SUV', icon: '🚙', stats: { speed: 70, handling: 74, acceleration: 75 } }
    ],
    motorcycles: [
        { model: 'akuma', name: 'Akuma', description: 'Sport motorcycle', icon: '🏍️', stats: { speed: 92, handling: 95, acceleration: 88 } },
        { model: 'bagger', name: 'Bagger', description: 'Touring motorcycle', icon: '🏍️', stats: { speed: 78, handling: 82, acceleration: 75 } },
        { model: 'bati', name: 'Bati 801', description: 'Super sport bike', icon: '🏍️', stats: { speed: 95, handling: 98, acceleration: 92 } },
        { model: 'carbonrs', name: 'Carbon RS', description: 'Street motorcycle', icon: '🏍️', stats: { speed: 89, handling: 93, acceleration: 86 } },
        { model: 'daemon', name: 'Daemon', description: 'Chopper motorcycle', icon: '🏍️', stats: { speed: 76, handling: 79, acceleration: 73 } },
        { model: 'double', name: 'Double T', description: 'Cruiser motorcycle', icon: '🏍️', stats: { speed: 80, handling: 85, acceleration: 77 } },
        { model: 'faggio2', name: 'Faggio', description: 'Scooter', icon: '🏍️', stats: { speed: 45, handling: 88, acceleration: 42 } },
        { model: 'hakuchou', name: 'Hakuchou', description: 'Japanese sport bike', icon: '🏍️', stats: { speed: 94, handling: 96, acceleration: 91 } },
        { model: 'hexer', name: 'Hexer', description: 'Chopper style', icon: '🏍️', stats: { speed: 74, handling: 77, acceleration: 71 } },
        { model: 'innovation', name: 'Innovation', description: 'Futuristic bike', icon: '🏍️', stats: { speed: 87, handling: 90, acceleration: 84 } }
    ],
    planes: [
        { model: 'luxor', name: 'Luxor', description: 'Private jet', icon: '✈️', stats: { speed: 85, handling: 65, acceleration: 80 } },
        { model: 'shamal', name: 'Shamal', description: 'Business jet', icon: '✈️', stats: { speed: 88, handling: 67, acceleration: 83 } },
        { model: 'titan', name: 'Titan', description: 'Cargo plane', icon: '✈️', stats: { speed: 75, handling: 55, acceleration: 70 } },
        { model: 'lazer', name: 'P-996 Lazer', description: 'Military fighter jet', icon: '✈️', stats: { speed: 98, handling: 95, acceleration: 95 } },
        { model: 'hydra', name: 'Hydra', description: 'VTOL fighter', icon: '✈️', stats: { speed: 96, handling: 92, acceleration: 93 } },
        { model: 'velum', name: 'Velum', description: 'Small aircraft', icon: '✈️', stats: { speed: 70, handling: 75, acceleration: 65 } },
        { model: 'mammatus', name: 'Mammatus', description: 'Light aircraft', icon: '✈️', stats: { speed: 72, handling: 78, acceleration: 67 } },
        { model: 'duster', name: 'Duster', description: 'Crop duster', icon: '✈️', stats: { speed: 68, handling: 82, acceleration: 63 } },
        { model: 'stunt', name: 'Stunt Plane', description: 'Aerobatic plane', icon: '✈️', stats: { speed: 74, handling: 95, acceleration: 69 } },
        { model: 'cuban800', name: 'Cuban 800', description: 'Vintage plane', icon: '✈️', stats: { speed: 73, handling: 73, acceleration: 68 } }
    ],
    helicopters: [
        { model: 'maverick', name: 'Maverick', description: 'Civilian helicopter', icon: '🚁', stats: { speed: 78, handling: 85, acceleration: 73 } },
        { model: 'frogger', name: 'Frogger', description: 'Light helicopter', icon: '🚁', stats: { speed: 80, handling: 88, acceleration: 75 } },
        { model: 'supervolito', name: 'SuperVolito', description: 'Luxury helicopter', icon: '🚁', stats: { speed: 82, handling: 87, acceleration: 77 } },
        { model: 'buzzard2', name: 'Buzzard', description: 'Attack helicopter', icon: '🚁', stats: { speed: 85, handling: 90, acceleration: 80 } },
        { model: 'savage', name: 'Savage', description: 'Military attack heli', icon: '🚁', stats: { speed: 83, handling: 88, acceleration: 78 } },
        { model: 'cargobob', name: 'Cargobob', description: 'Transport helicopter', icon: '🚁', stats: { speed: 70, handling: 75, acceleration: 65 } },
        { model: 'annihilator', name: 'Annihilator', description: 'Heavy attack heli', icon: '🚁', stats: { speed: 81, handling: 86, acceleration: 76 } },
        { model: 'swift', name: 'Swift', description: 'Executive helicopter', icon: '🚁', stats: { speed: 84, handling: 89, acceleration: 79 } },
        { model: 'volatus', name: 'Volatus', description: 'Modern helicopter', icon: '🚁', stats: { speed: 86, handling: 91, acceleration: 81 } },
        { model: 'valkyrie', name: 'Valkyrie', description: 'Military transport', icon: '🚁', stats: { speed: 75, handling: 80, acceleration: 70 } }
    ],
    boats: [
        { model: 'seashark', name: 'Seashark', description: 'Jet ski', icon: '🚤', stats: { speed: 85, handling: 92, acceleration: 88 } },
        { model: 'dinghy', name: 'Dinghy', description: 'Small boat', icon: '🚤', stats: { speed: 65, handling: 85, acceleration: 70 } },
        { model: 'jetmax', name: 'Jetmax', description: 'Speed boat', icon: '🚤', stats: { speed: 90, handling: 88, acceleration: 87 } },
        { model: 'speeder', name: 'Speeder', description: 'Racing boat', icon: '🚤', stats: { speed: 92, handling: 90, acceleration: 89 } },
        { model: 'squalo', name: 'Squalo', description: 'Sports boat', icon: '🚤', stats: { speed: 88, handling: 86, acceleration: 85 } },
        { model: 'toro', name: 'Toro', description: 'Luxury yacht', icon: '🚤', stats: { speed: 70, handling: 75, acceleration: 68 } },
        { model: 'tropic', name: 'Tropic', description: 'Pleasure boat', icon: '🚤', stats: { speed: 75, handling: 80, acceleration: 73 } },
        { model: 'marquis', name: 'Marquis', description: 'Classic yacht', icon: '🚤', stats: { speed: 72, handling: 77, acceleration: 70 } },
        { model: 'predator', name: 'Predator', description: 'Police boat', icon: '🚤', stats: { speed: 82, handling: 83, acceleration: 80 } },
        { model: 'submersible', name: 'Submersible', description: 'Submarine', icon: '🚤', stats: { speed: 45, handling: 60, acceleration: 50 } }
    ],
    emergency: [
        { model: 'police', name: 'Police Cruiser', description: 'Standard police car', icon: '🚨', stats: { speed: 80, handling: 82, acceleration: 78 } },
        { model: 'police2', name: 'Police Buffalo', description: 'High-performance police', icon: '🚨', stats: { speed: 85, handling: 85, acceleration: 83 } },
        { model: 'police3', name: 'Police Interceptor', description: 'Pursuit vehicle', icon: '🚨', stats: { speed: 88, handling: 87, acceleration: 86 } },
        { model: 'policeb', name: 'Police Bike', description: 'Police motorcycle', icon: '🚨', stats: { speed: 90, handling: 92, acceleration: 88 } },
        { model: 'ambulance', name: 'Ambulance', description: 'Emergency medical', icon: '🚨', stats: { speed: 70, handling: 75, acceleration: 73 } },
        { model: 'firetruk', name: 'Fire Truck', description: 'Emergency response', icon: '🚨', stats: { speed: 65, handling: 70, acceleration: 68 } },
        { model: 'sheriff', name: 'Sheriff Cruiser', description: 'County police', icon: '🚨', stats: { speed: 78, handling: 80, acceleration: 76 } },
        { model: 'policet', name: 'Police Transporter', description: 'Riot control', icon: '🚨', stats: { speed: 72, handling: 78, acceleration: 70 } },
        { model: 'fbi', name: 'FIB Buffalo', description: 'Federal agents', icon: '🚨', stats: { speed: 87, handling: 86, acceleration: 85 } },
        { model: 'fbi2', name: 'FIB SUV', description: 'Federal SUV', icon: '🚨', stats: { speed: 75, handling: 80, acceleration: 78 } }
    ],
    military: [
        { model: 'rhino', name: 'Rhino Tank', description: 'Main battle tank', icon: '🎖️', stats: { speed: 45, handling: 40, acceleration: 60 } },
        { model: 'crusader', name: 'Crusader', description: 'Military truck', icon: '🎖️', stats: { speed: 55, handling: 60, acceleration: 58 } },
        { model: 'barracks', name: 'Barracks', description: 'Military transport', icon: '🎖️', stats: { speed: 60, handling: 65, acceleration: 62 } },
        { model: 'insurgent', name: 'Insurgent', description: 'Armored vehicle', icon: '🎖️', stats: { speed: 70, handling: 75, acceleration: 73 } },
        { model: 'technical', name: 'Technical', description: 'Armed pickup', icon: '🎖️', stats: { speed: 75, handling: 78, acceleration: 76 } },
        { model: 'apc', name: 'APC', description: 'Armored personnel carrier', icon: '🎖️', stats: { speed: 50, handling: 55, acceleration: 65 } },
        { model: 'khanjali', name: 'TM-02 Khanjali', description: 'Modern tank', icon: '🎖️', stats: { speed: 48, handling: 45, acceleration: 70 } },
        { model: 'halftrack', name: 'Half-track', description: 'WWII vehicle', icon: '🎖️', stats: { speed: 52, handling: 58, acceleration: 55 } },
        { model: 'aa_trailer', name: 'Anti-Aircraft', description: 'AA trailer', icon: '🎖️', stats: { speed: 40, handling: 50, acceleration: 45 } },
        { model: 'trailersmall2', name: 'Army Trailer', description: 'Military trailer', icon: '🎖️', stats: { speed: 35, handling: 45, acceleration: 40 } }
    ],
    trucks: [
        { model: 'packer', name: 'Packer', description: 'Car transporter', icon: '🚛', stats: { speed: 65, handling: 55, acceleration: 60 } },
        { model: 'phantom', name: 'Phantom', description: 'Semi truck', icon: '🚛', stats: { speed: 70, handling: 60, acceleration: 65 } },
        { model: 'hauler', name: 'Hauler', description: 'Heavy hauler', icon: '🚛', stats: { speed: 68, handling: 58, acceleration: 63 } },
        { model: 'mule', name: 'Mule', description: 'Commercial truck', icon: '🚛', stats: { speed: 62, handling: 65, acceleration: 60 } },
        { model: 'pounder', name: 'Pounder', description: 'Large truck', icon: '🚛', stats: { speed: 64, handling: 62, acceleration: 61 } },
        { model: 'benson', name: 'Benson', description: 'Medium truck', icon: '🚛', stats: { speed: 66, handling: 64, acceleration: 63 } },
        { model: 'flatbed', name: 'Flatbed', description: 'Flatbed truck', icon: '🚛', stats: { speed: 63, handling: 61, acceleration: 59 } },
        { model: 'mixer', name: 'Mixer', description: 'Cement mixer', icon: '🚛', stats: { speed: 58, handling: 55, acceleration: 56 } },
        { model: 'trash', name: 'Trash Truck', description: 'Waste management', icon: '🚛', stats: { speed: 55, handling: 58, acceleration: 53 } },
        { model: 'tiptruck', name: 'Tipper', description: 'Dump truck', icon: '🚛', stats: { speed: 60, handling: 56, acceleration: 57 } }
    ],
    vans: [
        { model: 'burrito', name: 'Burrito', description: 'Panel van', icon: '🚐', stats: { speed: 68, handling: 72, acceleration: 65 } },
        { model: 'speedo', name: 'Speedo', description: 'Delivery van', icon: '🚐', stats: { speed: 70, handling: 74, acceleration: 67 } },
        { model: 'rumpo', name: 'Rumpo', description: 'Work van', icon: '🚐', stats: { speed: 66, handling: 70, acceleration: 63 } },
        { model: 'youga', name: 'Youga', description: 'Hippie van', icon: '🚐', stats: { speed: 64, handling: 68, acceleration: 61 } },
        { model: 'surfer', name: 'Surfer', description: 'Beach van', icon: '🚐', stats: { speed: 62, handling: 75, acceleration: 59 } },
        { model: 'paradise', name: 'Paradise', description: 'Party van', icon: '🚐', stats: { speed: 65, handling: 71, acceleration: 62 } },
        { model: 'minivan', name: 'Minivan', description: 'Family van', icon: '🚐', stats: { speed: 67, handling: 73, acceleration: 64 } },
        { model: 'camper', name: 'Camper', description: 'RV camper', icon: '🚐', stats: { speed: 60, handling: 65, acceleration: 57 } },
        { model: 'journey', name: 'Journey', description: 'Luxury van', icon: '🚐', stats: { speed: 69, handling: 75, acceleration: 66 } },
        { model: 'boxville', name: 'Boxville', description: 'Box truck', icon: '🚐', stats: { speed: 58, handling: 62, acceleration: 55 } }
    ],
    classic: [
        { model: 'monroe', name: 'Monroe', description: 'Classic supercar', icon: '🏛️', stats: { speed: 85, handling: 78, acceleration: 82 } },
        { model: 'stinger', name: 'Stinger', description: 'Vintage roadster', icon: '🏛️', stats: { speed: 80, handling: 85, acceleration: 77 } },
        { model: 'coquette2', name: 'Coquette Classic', description: 'Classic sports', icon: '🏛️', stats: { speed: 82, handling: 80, acceleration: 79 } },
        { model: 'jb700', name: 'JB 700', description: 'Classic spy car', icon: '🏛️', stats: { speed: 78, handling: 76, acceleration: 75 } },
        { model: 'tornado', name: 'Tornado', description: 'Classic muscle', icon: '🏛️', stats: { speed: 70, handling: 65, acceleration: 73 } },
        { model: 'peyote', name: 'Peyote', description: 'Classic convertible', icon: '🏛️', stats: { speed: 72, handling: 67, acceleration: 69 } },
        { model: 'manana', name: 'Manana', description: 'Vintage coupe', icon: '🏛️', stats: { speed: 68, handling: 63, acceleration: 65 } },
        { model: 'voodoo2', name: 'Voodoo', description: 'Lowrider classic', icon: '🏛️', stats: { speed: 66, handling: 70, acceleration: 63 } },
        { model: 'roosevelt', name: 'Roosevelt', description: 'Vintage luxury', icon: '🏛️', stats: { speed: 65, handling: 62, acceleration: 68 } },
        { model: 'franken_stange', name: 'Franken Stange', description: 'Horror classic', icon: '🏛️', stats: { speed: 74, handling: 68, acceleration: 71 } }
    ],
    offroad: [
        { model: 'sandking', name: 'Sandking XL', description: 'Monster truck', icon: '🏔️', stats: { speed: 75, handling: 85, acceleration: 78 } },
        { model: 'rebel2', name: 'Rebel', description: 'Off-road pickup', icon: '🏔️', stats: { speed: 72, handling: 88, acceleration: 75 } },
        { model: 'bodhi2', name: 'Bodhi', description: 'Off-road SUV', icon: '🏔️', stats: { speed: 70, handling: 90, acceleration: 73 } },
        { model: 'dune', name: 'Dune Buggy', description: 'Sand buggy', icon: '🏔️', stats: { speed: 78, handling: 92, acceleration: 80 } },
        { model: 'bfinjection', name: 'BF Injection', description: 'Beach buggy', icon: '🏔️', stats: { speed: 76, handling: 95, acceleration: 78 } },
        { model: 'kalahari', name: 'Kalahari', description: 'Desert vehicle', icon: '🏔️', stats: { speed: 74, handling: 87, acceleration: 76 } },
        { model: 'bifta', name: 'Bifta', description: 'Off-road buggy', icon: '🏔️', stats: { speed: 80, handling: 93, acceleration: 82 } },
        { model: 'dubsta3', name: 'Dubsta 6x6', description: 'Six-wheel drive', icon: '🏔️', stats: { speed: 68, handling: 85, acceleration: 70 } },
        { model: 'marshall', name: 'Marshall', description: 'Monster truck', icon: '🏔️', stats: { speed: 65, handling: 80, acceleration: 68 } },
        { model: 'riata', name: 'Riata', description: 'Off-road pickup', icon: '🏔️', stats: { speed: 73, handling: 89, acceleration: 75 } }
    ],
    utility: [
        { model: 'taxi', name: 'Taxi', description: 'City taxi', icon: '🔧', stats: { speed: 70, handling: 75, acceleration: 68 } },
        { model: 'bus', name: 'Bus', description: 'City bus', icon: '🔧', stats: { speed: 50, handling: 55, acceleration: 48 } },
        { model: 'coach', name: 'Coach', description: 'Tour bus', icon: '🔧', stats: { speed: 55, handling: 60, acceleration: 52 } },
        { model: 'tourbus', name: 'Tour Bus', description: 'Sightseeing bus', icon: '🔧', stats: { speed: 52, handling: 58, acceleration: 50 } },
        { model: 'airbus', name: 'Airport Bus', description: 'Airport shuttle', icon: '🔧', stats: { speed: 58, handling: 62, acceleration: 55 } },
        { model: 'rentalbus', name: 'Rental Shuttle', description: 'Rental bus', icon: '🔧', stats: { speed: 56, handling: 60, acceleration: 53 } },
        { model: 'stockade', name: 'Stockade', description: 'Armored truck', icon: '🔧', stats: { speed: 65, handling: 68, acceleration: 62 } },
        { model: 'limo2', name: 'Limousine', description: 'Stretch limo', icon: '🔧', stats: { speed: 72, handling: 65, acceleration: 70 } },
        { model: 'stretch', name: 'Stretch', description: 'Classic limo', icon: '🔧', stats: { speed: 70, handling: 63, acceleration: 68 } },
        { model: 'tractor2', name: 'Fieldmaster', description: 'Farm tractor', icon: '🔧', stats: { speed: 40, handling: 70, acceleration: 45 } }
    ]
};

// Enhanced menu functions
function showMenu() {
    console.log('Showing enhanced car menu...');
    const menu = document.getElementById('carMenu');
    menu.classList.add('show');
    menu.style.display = 'block';
    showCategory('sports');
    startVehicleInfoUpdates();
    
    // Add entrance animation
    setTimeout(() => {
        menu.style.transform = 'translate(-50%, -50%) scale(1)';
    }, 50);
}

function closeMenu() {
    console.log('Closing enhanced car menu...');
    const menu = document.getElementById('carMenu');
    menu.classList.remove('show');
    
    // Add exit animation
    menu.style.transform = 'translate(-50%, -50%) scale(0.95)';
    
    setTimeout(() => {
        menu.style.display = 'none';
        stopVehicleInfoUpdates();
    }, 300);
    
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(() => {}); // Ignore fetch errors
}

function showCategory(category) {
    currentCategory = category;
    
    // Clear search
    document.getElementById('searchInput').value = '';
    
    // Update tab buttons with enhanced animation
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('active');
        btn.style.transform = '';
    });
    
    // Find and activate the correct tab
    const categoryMap = {
        'sports': '🏎️', 'super': '🚀', 'muscle': '💪', 'suvs': '🚙', 
        'motorcycles': '🏍️', 'planes': '✈️', 'helicopters': '🚁', 'boats': '🚤',
        'emergency': '🚨', 'military': '🎖️', 'trucks': '🚛', 'vans': '🚐',
        'classic': '🏛️', 'offroad': '🏔️', 'utility': '🔧'
    };
    
    const targetIcon = categoryMap[category];
    document.querySelectorAll('.tab-btn').forEach(btn => {
        const iconSpan = btn.querySelector('.tab-icon');
        if (iconSpan && iconSpan.textContent.includes(targetIcon)) {
            btn.classList.add('active');
        }
    });
    
    populateVehicles(category);
}

function populateVehicles(category, searchTerm = '') {
    const grid = document.getElementById('vehiclesGrid');
    grid.innerHTML = '';
    
    if (carDatabase[category]) {
        let vehicles = carDatabase[category];
        
        // Filter by search term if provided
        if (searchTerm) {
            vehicles = vehicles.filter(car => 
                car.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                car.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                car.model.toLowerCase().includes(searchTerm.toLowerCase())
            );
        }
        
        vehicles.forEach((car, index) => {
            const vehicleCard = document.createElement('div');
            vehicleCard.className = 'vehicle-card';
            vehicleCard.onclick = () => selectCar(car.model, car.name);
            
            // Add staggered animation delay
            vehicleCard.style.animationDelay = `${index * 0.05}s`;
            vehicleCard.classList.add('fade-in');
            
            vehicleCard.innerHTML = `
                <div class="vehicle-name">${car.name}</div>
            `;
            grid.appendChild(vehicleCard);
        });

        // Show message if no vehicles found
        if (vehicles.length === 0) {
            grid.innerHTML = `
                <div style="grid-column: 1 / -1; text-align: center; color: var(--text-muted); padding: 40px;">
                    <div style="font-size: 48px; margin-bottom: 16px;">🔍</div>
                    <div style="font-size: 18px; margin-bottom: 8px;">No vehicles found</div>
                    <div style="font-size: 14px;">Try adjusting your search terms</div>
                </div>
            `;
        }
    }
}

function searchVehicles() {
    const searchTerm = document.getElementById('searchInput').value;
    
    // Clear previous timeout
    if (searchTimeout) {
        clearTimeout(searchTimeout);
    }
    
    // Debounce search
    searchTimeout = setTimeout(() => {
        if (searchTerm.length === 0) {
            populateVehicles(currentCategory);
            return;
        }
        
        if (searchTerm.length < 2) {
            return;
        }
        
        // Search across all categories with enhanced results
        const grid = document.getElementById('vehiclesGrid');
        grid.innerHTML = '';
        
        let foundVehicles = [];
        
        Object.keys(carDatabase).forEach(category => {
            const vehicles = carDatabase[category].filter(car => 
                car.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                car.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                car.model.toLowerCase().includes(searchTerm.toLowerCase())
            );
            
            vehicles.forEach(car => {
                foundVehicles.push({...car, category: category});
            });
        });
        
        if (foundVehicles.length > 0) {
            foundVehicles.forEach((car, index) => {
                const vehicleCard = document.createElement('div');
                vehicleCard.className = 'vehicle-card';
                vehicleCard.onclick = () => selectCar(car.model, car.name);
                vehicleCard.style.animationDelay = `${index * 0.05}s`;
                vehicleCard.classList.add('fade-in');
                
                vehicleCard.innerHTML = `
                    <div class="vehicle-name">${car.name}</div>
                    <div style="font-size: 0.5rem; color: var(--primary-green); margin-top: 2px; font-weight: 600; text-align: center;">
                        ${car.category.toUpperCase()}
                    </div>
                `;
                grid.appendChild(vehicleCard);
            });
        } else {
            grid.innerHTML = `
                <div style="grid-column: 1 / -1; text-align: center; color: var(--text-muted); padding: 40px;">
                    <div style="font-size: 48px; margin-bottom: 16px;">❌</div>
                    <div style="font-size: 18px; margin-bottom: 8px;">No vehicles found</div>
                    <div style="font-size: 14px;">No vehicles match "${searchTerm}"</div>
                </div>
            `;
        }
    }, 300);
}

function selectCar(model, name) {
    selectedCar = { model, name };
    
    // Enhanced visual selection with animation
    document.querySelectorAll('.vehicle-card').forEach(card => {
        card.classList.remove('selected');
        card.style.transform = '';
    });
    
    const selectedCard = event.target.closest('.vehicle-card');
    if (selectedCard) {
        selectedCard.classList.add('selected');
        selectedCard.style.transform = 'scale(1.02)';
    }
    
    // Update spawn button with enhanced styling
    const spawnBtn = document.getElementById('spawnBtn');
    spawnBtn.disabled = false;
    updateSpawnButton();
    
    // Add haptic feedback simulation
    if (navigator.vibrate) {
        navigator.vibrate(50);
    }
}

function selectStyle(style) {
    selectedStyle = style;
    
    // Enhanced style selection
    document.querySelectorAll('.option-btn').forEach(btn => {
        btn.classList.remove('active');
        btn.style.transform = '';
    });
    
    // Find and activate the correct style button
    const styleMap = {
        'default': '📦', 'tuned': '🔧', 'clean': '✨',
        'dirty': '🏜️', 'race': '🏁', 'luxury': '💎'
    };
    
    const targetIcon = styleMap[style];
    document.querySelectorAll('.option-btn').forEach(btn => {
        const iconSpan = btn.querySelector('.option-icon');
        if (iconSpan && iconSpan.textContent.includes(targetIcon)) {
            btn.classList.add('active');
            btn.style.transform = 'scale(1.02)';
        }
    });
    
    if (selectedCar) {
        updateSpawnButton();
    }
}

function selectTarget(target) {
    selectedTarget = target;
    
    // Enhanced target selection
    document.querySelectorAll('.option-btn').forEach(btn => {
        btn.classList.remove('active');
        btn.style.transform = '';
    });
    
    // Find and activate the correct target button
    const targetMap = {
        'self': '👤', 'nearest': '🎯', 'custom': '🔢'
    };
    
    const targetIcon = targetMap[target];
    document.querySelectorAll('.option-btn').forEach(btn => {
        const iconSpan = btn.querySelector('.option-icon');
        if (iconSpan && iconSpan.textContent.includes(targetIcon)) {
            btn.classList.add('active');
            btn.style.transform = 'scale(1.02)';
        }
    });
    
    // Show/hide player ID input with animation
    const playerIdInput = document.getElementById('playerIdInput');
    if (target === 'custom') {
        playerIdInput.classList.add('show');
        playerIdInput.style.display = 'block';
    } else {
        playerIdInput.classList.remove('show');
        playerIdInput.style.display = 'none';
    }
    
    if (selectedCar) {
        updateSpawnButton();
    }
}

function updateSpawnButton() {
    const spawnBtn = document.getElementById('spawnBtn');
    let targetText = '';
    
    if (selectedTarget === 'self') {
        targetText = 'for Me';
    } else if (selectedTarget === 'nearest') {
        targetText = 'for Nearest Player';
    } else if (selectedTarget === 'custom') {
        const playerId = document.getElementById('targetPlayerId').value;
        targetText = playerId ? `for Player ${playerId}` : 'for Player ID';
    }
    
    spawnBtn.innerHTML = `
        🚗 Spawn ${selectedCar.name} ${targetText}
        <span style="color: rgba(0,0,0,0.7); font-weight: 500;">(${selectedStyle})</span>
    `;
}

function spawnSelectedCar() {
    if (!selectedCar) {
        showNotification('Please select a car first!', 'error');
        return;
    }
    
    let targetPlayerId = null;
    if (selectedTarget === 'custom') {
        const playerIdInput = document.getElementById('targetPlayerId');
        targetPlayerId = parseInt(playerIdInput.value);
        if (!targetPlayerId || targetPlayerId < 1 || targetPlayerId > 255) {
            showNotification('Please enter a valid Player ID (1-255)!', 'error');
            return;
        }
    }
    
    // Add loading state
    const spawnBtn = document.getElementById('spawnBtn');
    const originalText = spawnBtn.innerHTML;
    spawnBtn.classList.add('loading');
    spawnBtn.disabled = true;
    spawnBtn.innerHTML = 'Spawning...';
    
    fetch(`https://${GetParentResourceName()}/spawnCar`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            model: selectedCar.model,
            style: selectedStyle,
            target: selectedTarget,
            targetPlayerId: targetPlayerId
        })
    });
    
    // Restore button after delay
    setTimeout(() => {
        spawnBtn.classList.remove('loading');
        spawnBtn.disabled = false;
        spawnBtn.innerHTML = originalText;
    }, 2000);
    
    // Close the menu after spawning
    setTimeout(() => {
        closeMenu();
    }, 1000);
}

function vehicleAction(action, data = null) {
    let requestData = { action: action };
    if (data !== null) {
        requestData.data = data;
    }
    
    fetch(`https://${GetParentResourceName()}/vehicleAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(requestData)
    }).catch(() => {});
    
    // Update vehicle info after action
    setTimeout(requestVehicleInfo, 500);
}

function requestVehicleInfo() {
    fetch(`https://${GetParentResourceName()}/getVehicleInfo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(() => {});
}

function updateVehicleInfo(info) {
    if (!info || !info.inVehicle) {
        // No vehicle - enhanced styling
        document.getElementById('vehicleName').textContent = 'No Vehicle';
        document.getElementById('vehicleSpeed').textContent = '0 MPH';
        document.getElementById('vehicleSeat').textContent = '-';
        document.getElementById('engineStatus').textContent = '-';
        document.getElementById('vehicleHealth').textContent = '-';
        document.getElementById('engineHealth').textContent = '-';
        document.getElementById('bodyHealth').textContent = '-';
        document.getElementById('healthBar').style.width = '0%';
        
        // Disable vehicle controls with enhanced styling
        document.querySelectorAll('.control-btn').forEach(btn => {
            btn.disabled = true;
            btn.style.opacity = '0.5';
            btn.style.pointerEvents = 'none';
        });
        return;
    }

    // Update vehicle information with enhanced animations
    document.getElementById('vehicleName').textContent = info.name || 'Unknown';
    document.getElementById('vehicleSpeed').textContent = `${Math.round(info.speed || 0)} MPH`;
    
    // Enhanced seat position display
    const seatNames = { 
        [-1]: 'Driver', [0]: 'Passenger', [1]: 'Rear Left', 
        [2]: 'Rear Right', [3]: 'Rear Center' 
    };
    document.getElementById('vehicleSeat').textContent = seatNames[info.seat] || `Seat ${info.seat}`;
    
    // Enhanced engine status
    const engineElement = document.getElementById('engineStatus');
    engineElement.textContent = info.engineRunning ? 'Running' : 'Off';
    engineElement.style.color = info.engineRunning ? 'var(--primary-green)' : '#ff6b6b';
    
    // Enhanced health information with animations
    const vehicleHealth = Math.round((info.health || 0) / 10);
    const engineHealth = Math.round((info.engineHealth || 0) / 10);
    const bodyHealth = Math.round((info.bodyHealth || 0) / 10);
    
    document.getElementById('vehicleHealth').textContent = `${vehicleHealth}%`;
    document.getElementById('engineHealth').textContent = `${engineHealth}%`;
    document.getElementById('bodyHealth').textContent = `${bodyHealth}%`;
    
    // Enhanced health bar with color transitions
    const healthBar = document.getElementById('healthBar');
    healthBar.style.width = `${vehicleHealth}%`;
    
    if (vehicleHealth > 75) {
        healthBar.style.background = 'linear-gradient(90deg, var(--primary-green), #33ffaa)';
    } else if (vehicleHealth > 50) {
        healthBar.style.background = 'linear-gradient(90deg, #ffff00, var(--primary-green))';
    } else if (vehicleHealth > 25) {
        healthBar.style.background = 'linear-gradient(90deg, #ff8800, #ffff00)';
    } else {
        healthBar.style.background = 'linear-gradient(90deg, #ff0000, #ff8800)';
    }
    
    // Enable vehicle controls with enhanced styling
    document.querySelectorAll('.control-btn').forEach(btn => {
        btn.disabled = false;
        btn.style.opacity = '1';
        btn.style.pointerEvents = 'auto';
    });
}

function startVehicleInfoUpdates() {
    requestVehicleInfo(); // Initial request
    updateInterval = setInterval(requestVehicleInfo, 1000); // Update every second
}

function stopVehicleInfoUpdates() {
    if (updateInterval) {
        clearInterval(updateInterval);
        updateInterval = null;
    }
}

function showNotification(message, type = 'info') {
    // Create enhanced notification system
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'error' ? 'rgba(255, 0, 0, 0.9)' : 'rgba(0, 255, 136, 0.9)'};
        color: white;
        padding: 16px 24px;
        border-radius: 12px;
        font-weight: 600;
        z-index: 10000;
        backdrop-filter: blur(20px);
        animation: slideInRight 0.3s ease-out;
    `;
    notification.textContent = message;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease-in';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Enhanced event listeners
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeMenu();
    }
});

// Enhanced search input event listener
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            searchVehicles();
        });
    }
});

// Player ID input event listener
document.addEventListener('DOMContentLoaded', function() {
    const playerIdInput = document.getElementById('targetPlayerId');
    if (playerIdInput) {
        playerIdInput.addEventListener('input', function() {
            if (selectedCar) {
                updateSpawnButton();
            }
        });
    }
});

// Enhanced message listener
window.addEventListener('message', function(event) {
    if (event.data.type === 'showMenu') {
        showMenu();
    } else if (event.data.type === 'updateVehicleInfo') {
        updateVehicleInfo(event.data.info);
    }
});

// Enhanced initialization
document.addEventListener('DOMContentLoaded', function() {
    console.log('Enhanced car menu loaded successfully');
    
    // Ensure menu is hidden on load
    const carMenu = document.getElementById('carMenu');
    if (carMenu) {
        carMenu.style.display = 'none';
    }
    
    const spawnBtn = document.getElementById('spawnBtn');
    if (spawnBtn) {
        spawnBtn.disabled = true;
    }
    
    // Initialize first category
    populateVehicles('sports');
});
