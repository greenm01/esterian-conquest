package ec

Sector :: struct {
	x: int,
	y: int,
}

serialize_sector :: proc(s: ^Serializer, sr: ^Sector, loc := #caller_location) -> bool {
    serialize(s, &sr.x, loc) or_return
    serialize(s, &sr.y, loc) or_return
    return true
}