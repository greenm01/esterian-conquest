package ec

GameConfig :: struct{
	num_empires: int,
	host_name: string,
	game_name: string,
	server_ip: string,
	port: int,
}

serialize_game_config :: proc(s: ^Serializer, g: ^GameConfig, loc := #caller_location) -> bool {
    serialize(s, &g.num_empires, loc) or_return
    serialize(s, &g.host_name, loc) or_return
    serialize(s, &g.game_name, loc) or_return
    serialize(s, &g.server_ip, loc) or_return
    serialize(s, &g.port, loc) or_return
    return true
}