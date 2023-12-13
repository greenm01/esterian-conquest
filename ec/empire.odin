package ec

// Empire contains empire data
Empire :: struct {
	key: int,
	name: string,
	planets: []int,
	prev_planets: int,
	fleets: map[int]Fleet,
	reports: []Report,
	messages: []Message,
	tax: int,
	planet_db: PlanetDB,
	autopilot: bool,
	status: string,
	cur_prod: int,
	prev_prod: int,
	bio: string,
}

serialize_empire :: proc(s: ^Serializer, e: ^Empire, loc := #caller_location) -> bool {
    serialize(s, &e.key, loc) or_return
    serialize(s, &e.name, loc) or_return
    serialize(s, &e.planets, loc) or_return
    serialize(s, &e.prev_planets, loc) or_return
    serialize(s, &e.fleets, loc) or_return
    serialize(s, &e.reports, loc) or_return
    serialize(s, &e.messages, loc) or_return
    serialize(s, &e.tax, loc) or_return
    serialize(s, &e.planet_db, loc) or_return
    serialize(s, &e.autopilot, loc) or_return
    serialize(s, &e.status, loc) or_return
    serialize(s, &e.cur_prod, loc) or_return
    serialize(s, &e.prev_prod, loc) or_return
    serialize(s, &e.bio, loc) or_return
    return true
}