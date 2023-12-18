package server

import "core:fmt"
import "core:os"

/*

TODO: Create a script or daemon that runs game maintenance at a prescribed time

*/

START_YEAR :: 3000

HOMEWORLD_MAX_PROD :: 100
HOMEWORLD_START_PROD :: 100
HOMEWORLD_KASPA :: 50
HOMEWORLD_ARMIES :: 100
HOMEWORLD_GROUND_BATTERIES :: 25

CONFIG_FILE :: "game_config.json"
DATA_FILE :: "game_data.dat"

main :: proc() {
	parse_args(os.args)
}

