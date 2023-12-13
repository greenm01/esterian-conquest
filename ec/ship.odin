package ec

Ship :: struct {
	key: int,
	class: int,
	armies: int,
}

serialize_ship :: proc(s: ^Serializer, sp: ^Ship, loc := #caller_location) -> bool {
    serialize(s, &sp.key, loc) or_return
    serialize(s, &sp.class, loc) or_return
    serialize(s, &sp.armies, loc) or_return
    return true
}