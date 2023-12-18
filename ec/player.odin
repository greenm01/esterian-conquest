package ec

Player :: struct {
	key: int,
	name: string,
	first_time: bool,
	last_year_on: int,
	year_join: int,
}

serialize_player :: proc(s: ^Serializer, p: ^Player, loc := #caller_location) -> bool {
    serialize(s, &p.key, loc) or_return
    serialize(s, &p.name, loc) or_return
    serialize(s, &p.first_time, loc) or_return
    serialize(s, &p.last_year_on, loc) or_return
    serialize(s, &p.year_join, loc) or_return
    return true
}