package ec2

// Ship Classes:
// 01 = Destroyer
// 02 = Cruiser
// 03 = Battleship
// 04 = Scout
// 05 = Troop Transport
// 06 = ETAC

Ship :: struct {
	key: int,
	class: int,
	armies: int,
}

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
