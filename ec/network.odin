package ec

ClientMessage :: union {
	Login,
	Query,
	Command,
}

Login :: struct {
	player: string,
	password: string,
}

serialize_login :: proc(s: ^Serializer, l: ^Login, loc := #caller_location) -> bool {
    serialize(s, &l.player, loc) or_return
    serialize(s, &l.password, loc) or_return
    return true
}

Query :: struct {
	query: string,
}

serialize_query :: proc(s: ^Serializer, q: ^Query, loc := #caller_location) -> bool {
    serialize(s, &q.query, loc) or_return
    return true
}
	
Command :: struct {
	command: string,
}
	
serialize_command :: proc(s: ^Serializer, c: ^Command, loc := #caller_location) -> bool {
    serialize(s, &c.command, loc) or_return
    return true
}