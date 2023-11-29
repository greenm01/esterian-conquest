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
		"                      new          # Initialize a new game\n" +
		"                      run          # Start the game server\n" +
		"                      maint        # Manually run turn maintenance [TODO]\n" +
		"                      stats        # Display game stastics [TODO]\n\n" +
		"                      version      # Display game version\n" +
		"                      help         # Show this help message\n\n" +
		"- Be sure to specify the game folder directory, e.g. ec2s new /User/mag/ec2/game1/\n\n" +
		"- Ensure you drop an updated 'config' file for each new game in this folder\n" +
		"  > Example 'config', with required fields:\n" +
		"  > \n" +
		"  > players: 4                     # Number of players in game\n" +
		"  > host: Toys In The Attic BBS    # Host system name\n" +
		"  > sysop: Mason Austin Green      # System operator name\n" +
		"  > launchDate: 2022-08-23         # Day to officialy start the game: YEAR-MM-DD\n" +
		"  > maintPeriod: 24                # Time between maintenance runs (hours) \n" +
		"  > maintTime: 00:01               # Daily maintenance time (hh:mm) 24hr format\n" +
		"  > ip: localhost                  # Your server's IP address\n" +
		"  > port: 1992                     # Port number\n\n" +
		"- To delete a game, delete the folder (save the config file for later use)\n"

parse_args :: proc(cli_args: []string) {
	context.logger = log.create_console_logger()
	arguments := cli_args[1:]
	log.debugf("arguments: %v\n", arguments)

	if len(arguments) < 1 {
		fmt.printf("%s", Usage)
		os.exit(1)
	}

	command := arguments[0]

	switch command {
	case NewGame:
		fmt.println("creating new game...\n")
		directory := arguments[1]
	case Maintenance:
		fmt.println("running game maintenance...\n")
	case Daemon:
		fmt.println("starting game daemon...\n")
	case Stats:
		fmt.println("show game stats: TODO\n")
	case Version:
		// TODO: Add game version variable
		fmt.println("Esterian Conquest v2.0\n")
	case Help:
		fmt.printf("%s", Usage)	
	case:
		fmt.println("unrecognized command... pass 'help' get list of available commands\n")
		os.exit(1)	
	}
	
}


