package ec2s

import "core:fmt"
import "core:os"

/*

TODO: Create a script or daemon that runs game maintenance at a prescribed time

*/

START_YEAR :: 3000
CONFIG_FILE :: "game_config.json"
DB_DIR :: "db"

main :: proc() {
	parse_args(os.args)
}

