package server

import "core:fmt"
import "core:os"

// TODO: Create a script or daemon that runs game maintenance at a prescribed time

/*	############################ 
	### DEFAUT GAME SETTINGS ###
	############################ */

START_YEAR :: 3000
// Homeworld settings
HOMEWORLD_MAX_PROD :: 100
HOMEWORLD_START_PROD :: 100
HOMEWORLD_KASPA :: 50
HOMEWORLD_ARMIES :: 100
HOMEWORLD_GROUND_BATTERIES :: 25
// Game files
CONFIG_FILE :: "game_config.json"
DATA_FILE :: "game_data.dat"

main :: proc() {
	parse_args(os.args)
}

