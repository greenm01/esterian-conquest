package server

Sector :: struct {
	x: int,
	y: int,
}

Planet :: struct {
	key: int,                // Database lookup key
	pos: Sector,             // Starmap position
	name: string,            // Planet name
	owner: int,              // Current owner
	prev_owner: int,         // Previous owner
	max_prod: int,           // Maximum production
	cur_prod: int,           // Current production
	kaspa: int,              // Kaspa currency
	armies: int,             // Armies
	ground_batteries: int,   // Ground Batteries
	star_dock: [dynamic]int, // Stardock contents
}

// Player's Planet Database
PlanetDB :: struct {
	// Map keys = Planet.ID
	name: map[int]string,
	year_scouted: map[int]int,
	year_viewed: map[int]int,
	max_prod: map[int]int,
	cur_prod: map[int]int,
	kaspa: map[int]int,
	owner: map[int]int,
	prev_owner: map[int]int,
	ownedFor: map[int]int,
	star_dock: map[int][dynamic]int,
	armies: map[int]int,
	ground_batteries: map[int]int,
	pos: map[int]Sector,
}

// Allocate memory for database records
init_planet_database :: proc(data: ^PlanetDB) {
	data.name = make(map[int]string)	
}

init_homeworld :: proc(p: ^Planet, empire: int) {
	p.owner = empire
	p.prev_owner = -1
	p.max_prod = 100
	p.cur_prod = 100
	p.kaspa = 50
	p.armies = 100
	p.ground_batteries = 25
}


