package ec

GameData :: struct {
	game_full: bool,
	game_year: int,
	game_config: GameConfig,
	starmap: StarMap,
	empires: map[int]Empire,
	players: map[int]Player,
}

init_game_data :: proc(gd: ^GameData) {
	gd.empires = make(map[int]Empire)
}

del_game_data :: proc(gd: ^GameData) {
	delete(gd.empires)
}

serialize_game_data :: proc(s: ^Serializer, d: ^GameData, loc := #caller_location) -> bool {
    serialize(s, &d.game_full, loc) or_return
    serialize(s, &d.game_year, loc) or_return
    serialize(s, &d.game_config, loc) or_return
    serialize(s, &d.starmap, loc) or_return
    serialize(s, &d.empires, loc) or_return
    serialize(s, &d.players, loc) or_return
    return true
}
