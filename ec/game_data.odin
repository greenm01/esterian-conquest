package ec

GameData :: struct {
	game_config: GameConfig,
	starmap: StarMap,
	empires: map[int]Empire,
}

serialize_game_data :: proc(s: ^Serializer, d: ^GameData, loc := #caller_location) -> bool {
    serialize(s, &d.game_config, loc) or_return
    serialize(s, &d.starmap, loc) or_return
    serialize(s, &d.empires, loc) or_return
    return true
}