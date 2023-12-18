package server

import "core:strings"
import "core:fmt"
import "core:os"

import "../ec"

// common utility procedures

data_file :: proc(path: string) -> string {
	f := [2]string{path, DATA_FILE}
	return strings.concatenate(f[:])
}

config_file :: proc(path: string) -> string {
	f := [2]string{path, CONFIG_FILE}
	return strings.concatenate(f[:])
}
	
load_game_data :: proc(path: string) -> ec.GameData {
	filename := data_file(path)
	data, ok := os.read_entire_file(filename, context.allocator)
	defer delete(data, context.allocator)
	if !ok {
		fmt.println("error opening game data file!")
		os.exit(1)
	}
	s: ec.Serializer
	ec.serializer_init_reader(&s, data)
	gd: ec.GameData
	ec.serialize(&s, &gd)
	return gd
}