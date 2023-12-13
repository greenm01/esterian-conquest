package ec

// Ship Classes:
// 01 = Destroyer
// 02 = Cruiser
// 03 = Battleship
// 04 = Scout
// 05 = Troop Transport
// 06 = ETAC

Fleet :: struct {
	key: int,
	ships: []Ship,
	pos: int,
	speed: int,
	max_speed: int,
	roe: int,
	eta: int,
	orders: int,
}

serialize_fleet :: proc(s: ^Serializer, f: ^Fleet, loc := #caller_location) -> bool {
    serialize(s, &f.key, loc) or_return
    serialize(s, &f.ships, loc) or_return
    serialize(s, &f.pos, loc) or_return
    serialize(s, &f.speed, loc) or_return
    serialize(s, &f.max_speed, loc) or_return
    serialize(s, &f.roe, loc) or_return
    serialize(s, &f.eta, loc) or_return
    serialize(s, &f.orders, loc) or_return
    return true
}
		
num_armies :: proc(f: Fleet) -> int {
	a := 0
	for s, i in f.ships {
		// Only troop transports can have armies!
		if s.class == 5 {
			a += s.armies
		} else {
			f.ships[i].armies = 0
		}
	}
	return a
}
