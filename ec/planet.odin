package ec

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
	stardock: []int, 		 // Stardock contents
}

serialize_planet :: proc(s: ^Serializer, p: ^Planet, loc := #caller_location) -> bool {
    serialize(s, &p.key, loc) or_return
    serialize(s, &p.pos, loc) or_return
    serialize(s, &p.name, loc) or_return
    serialize(s, &p.owner, loc) or_return
    serialize(s, &p.prev_owner, loc) or_return
    serialize(s, &p.max_prod, loc) or_return
    serialize(s, &p.cur_prod, loc) or_return
    serialize(s, &p.kaspa, loc) or_return
    serialize(s, &p.armies, loc) or_return
    serialize(s, &p.ground_batteries, loc) or_return
    serialize(s, &p.stardock, loc) or_return
    return true
}
		


// Planet Database
PlanetDB :: struct {
	// Map keys = planet's key
	name: map[int]string,
	year_scouted: map[int]int,
	year_viewed: map[int]int,
	max_prod: map[int]int,
	cur_prod: map[int]int,
	kaspa: map[int]int,
	owner: map[int]int,
	prev_owner: map[int]int,
	owned_for: map[int]int,
	star_dock: map[int][]int,
	armies: map[int]int,
	ground_batteries: map[int]int,
	pos: map[int]Sector,
}

serialize_planet_db :: proc(s: ^Serializer, db: ^PlanetDB, loc := #caller_location) -> bool {
    serialize(s, &db.name, loc) or_return
    serialize(s, &db.year_scouted, loc) or_return
    serialize(s, &db.year_viewed, loc) or_return
    serialize(s, &db.max_prod, loc) or_return
    serialize(s, &db.cur_prod, loc) or_return
    serialize(s, &db.kaspa, loc) or_return
    serialize(s, &db.owner, loc) or_return
    serialize(s, &db.prev_owner, loc) or_return
    serialize(s, &db.owned_for, loc) or_return
    serialize(s, &db.star_dock, loc) or_return
    serialize(s, &db.armies, loc) or_return
    serialize(s, &db.ground_batteries, loc) or_return
    serialize(s, &db.pos, loc) or_return
    return true
}

// Allocate memory for database records
init_planet_db :: proc(db: ^PlanetDB) {
	db.name = make(map[int]string)
	db.year_scouted = make(map[int]int)
	db.year_viewed = make(map[int]int)
	db.max_prod = make(map[int]int)
	db.cur_prod = make(map[int]int)
	db.kaspa = make(map[int]int)
	db.owner = make(map[int]int)
	db.prev_owner = make(map[int]int)
	db.owned_for = make(map[int]int)
	db.star_dock = make(map[int][]int)
	db.armies = make(map[int]int)
	db.ground_batteries = make(map[int]int)
	db.pos = make(map[int]Sector)
}

// Deallocate memory for database records
del_planet_db :: proc(db: ^PlanetDB) {
	delete(db.name)
	delete(db.year_scouted)
	delete(db.year_viewed)
	delete(db.max_prod)
	delete(db.cur_prod)
	delete(db.kaspa)
	delete(db.owner)
	delete(db.prev_owner)
	delete(db.owned_for)
	delete(db.star_dock)
	delete(db.armies)
	delete(db.ground_batteries)
	delete(db.pos)
}
