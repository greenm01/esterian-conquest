package cli

import "core:os"
import "core:log"
import "core:fmt"

Commands :: enum {
	NewGame,
	Maintenance,
	Daemon,
	Stats,
	Version,
	Help,
}

NewGame :: "new"
Maintenance :: "maint"
Daemon :: "run"
Version :: "version"
Help :: "help"
Stats :: "stats"

Usage ::"Esterian Conquest v2 Game Server\n\n" +
		"Usage: ec2s <command> [game path]\n\n" +
		"The commands are:\n\n" +
		"    new          # Initialize a new game\n" +
		"    run          # Start the game server\n" +
		"    maint        # Manually run turn maintenance [TODO]\n" +
		"    stats        # Display game stastics [TODO]\n" +
		"    version      # Display game version\n" +
		"    help         # Show this help message\n\n" +
		"- Be sure to specify the game folder directory, e.g. ec2s new /User/mag/ec2/game1/\n\n" +
		"- Ensure you drop an updated 'game_config.json' file for each new game in this folder\n\n" +
		"### Example with required fields ###\n\n" +
		"{\n" +
		"    \"num_players\": 4,\n" +
		"    \"host_name\": \"Toys In The Attic BBS\",\n" +
		"    \"sysop_name\": \"Mason Austin Green\",\n" +
		"    \"start_date\": \"2023-11-29\",\n" +
		"    \"start_time\": \"00:01\",\n" +
		"    \"maint_period\": 24,\n" +
		"    \"server_ip\": \"localhost\",\n" +
		"    \"port\": 1992,\n" +
		"}\n\n" 

parse_args :: proc(cli_args: []string) {
	arguments := cli_args[1:]

	if len(arguments) < 1 {
		fmt.printf("%s", Usage)
		os.exit(1)
	}

	command := arguments[0]

	switch command {
	case NewGame:
		fmt.println("creating new game...")
		directory := arguments[1]
	case Maintenance:
		fmt.println("running game maintenance...")
	case Daemon:
		fmt.println("starting game daemon...")
	case Stats:
		fmt.println("show game stats: TODO")
	case Version:
		// TODO: Add game version variable
		fmt.println("Esterian Conquest v2.0")
	case Help:
		fmt.printf("%s", Usage)	
	case:
		fmt.println("unrecognized command... pass 'help' get list of available commands")
		os.exit(1)	
	}
	
}


