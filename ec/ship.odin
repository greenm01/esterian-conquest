package ec

Ship :: struct {
	class: int,
	armies: int,
}

serialize_ship :: proc(s: ^Serializer, sp: ^Ship, loc := #caller_location) -> bool {
    serialize(s, &sp.class, loc) or_return
    serialize(s, &sp.armies, loc) or_return
    return true
}
