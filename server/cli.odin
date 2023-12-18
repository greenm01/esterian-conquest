package server

import "core:os"
import "core:fmt"

import "core:encoding/json"
import "core:strings"

import "../ec"

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
		"    maint        # Run turn maintenance\n" +
		"    stats        # Display game stastics\n" +
		"    version      # Display game version\n" +
		"    help         # Show this help message\n\n" +
		"- Be sure to specify the game folder directory," +
	  " e.g. ec2s new /User/mag/ec2/game1/\n\n" +
		"- Ensure you drop an updated '" + CONFIG_FILE + 
	  "' file for each new game in this folder\n\n" +
		"### Example with required fields ###\n\n" +
		"{\n" +
		"    \"num_players\": 4,\n" +
		"    \"host_name\": \"Toys In The Attic Game Server\",\n" +
		"    \"game_name\": \"EC Game #69\",\n" +
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
		check_2nd_argument(arguments)
		path := arguments[1]
		game_config := load_config(path)
		create_game(game_config, path)
	case Maintenance:
		check_2nd_argument(arguments)
		fmt.println("running game maintenance...")
	case Daemon:
		check_2nd_argument(arguments)
		path := arguments[1]
		game_config := load_config(path)
		init_server(game_config)
	case Stats:
		check_2nd_argument(arguments)
		fmt.println("show game stats: TODO")
	case Version:
		// TODO: Add game version variable
		fmt.println("Esterian Conquest v2.0")
	case Help:
		fmt.printf("%s", Usage)	
	case:
		fmt.println("unrecognized command... pass 'help' for list of commands")
		os.exit(1)	
	}
	
}

check_2nd_argument :: proc(arguments: []string) {
	if len(arguments) < 2 {
		fmt.println("Missing game directory... pass 'help' for list of commands")
		os.exit(1)
	}
}

load_config :: proc(path: string) -> ec.GameConfig {
	
	fmt.printf("loading %s...\n", CONFIG_FILE)
	
	f := [2]string{path, CONFIG_FILE}
	filename := strings.concatenate(f[:])
		
	// Load in your json file!
	data, ok := os.read_entire_file_from_filename(filename)
	if !ok {
		fmt.eprintln("Failed to load the config file!")
		os.exit(1)
	}
	defer delete(data) // Free the memory at the hermitian_adjoint
	
	// Parse the json file.
	config_data, err := json.parse(data)
	if err != .None {
		fmt.eprintln("Failed to parse the config file.")
		fmt.eprintln("Error:", err)
		os.exit(1)
	}

	// Access the Root Level Object
	config := config_data.(json.Object)

	// check the config file format
	for key in config {
		if key != "num_empires" && key != "host_name" && key != "game_name" &&
			 key != "server_ip" && key != "port" {
			fmt.eprintln("ERROR: Incorrect config format!")
			os.exit(1)		
		}
	}
		
	// Check for minimum number of players
	num_empires := int(config["num_empires"].(json.Float))
	if num_empires < 2 {
		fmt.eprintln("ERROR: Minimum number of empires is two!")
		os.exit(1)
	}	

	host_name := config["host_name"].(json.String)
	game_name := config["game_name"].(json.String)
	server_ip := config["server_ip"].(json.String)
	port := int(config["port"].(json.Float))
	
	fmt.println(
		"  number of empires:",
		num_empires,
		"\n  host name:",
		host_name,
		"\n  game name:",
		game_name,
		"\n  server ip:",
		server_ip,
		"\n  port:",
		port,
	)

	game_config := ec.GameConfig {
		num_empires,
		host_name,
		game_name,
		server_ip,
		port,
	}
	
	return game_config

}
