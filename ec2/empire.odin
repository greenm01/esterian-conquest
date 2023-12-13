package ec2

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
