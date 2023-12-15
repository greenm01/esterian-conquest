package server

import "core:os"
import "core:fmt"
import "core:strings"

import "../ec"

create_game :: proc(game_config: ec.GameConfig) {
	
	fmt.println("################################")
	fmt.println("##### Creating New EC Game #####")
	fmt.println("################################")

	/* #############################
	   ##### STARMAP & PLANETS #####
	   ############################# */	

	starmap := gen_starmap(game_config.num_empires)
	
	/* #########################
	   ##### EMPIRE SETUP  #####
	   ######################### */

	fmt.print("creating empires...")
	
	empires := make(map[int]ec.Empire)
	defer delete(empires)
	
	// create empires and assign homeworlds
	for hw, i in starmap.homeworlds {
		id := i + 1
		builder := strings.builder_make()
		strings.write_string(&builder, "Rogue ")
		strings.write_int(&builder, id)
		rogue := strings.to_string(builder)
		empires[id] = ec.Empire {
			key = id,
			name = rogue,
			planets = []int{hw},
			prev_planets = 1,
			tax = 50,
			autopilot = true,
			cur_prod = 100,
			prev_prod = 100,
			// TODO: make status an ENUM
			status = "ALIVE",
			bio = "We're an AI controlled empire. Come get us!",
		}
		
		// Alocate resources to homeworld
		init_homeworld(&starmap.planets[hw], id)	
	}

	fmt.println("done!")
	fmt.print("assigning fleets...")

	/*	## Assign fleets #####################################
	   	# Per classic EC, each empire get 4 starting fleets: #
	   	# - Two Fleets with one ETAC and a Cruiser escort    #
	   	# - Two Fleets with one Destroyers                   #
	   	# - Orders are to guard/blockade homeworld           #
		######################################################
	*/

	for _, empire in &empires {
		// create fleets
		fleets := make(map[int]ec.Fleet)
		defer delete(fleets)
		
		for f := 0; f < 4; f +=1 {
			fleets[f] = ec.Fleet {
				key = f,
				roe = 6,
				speed = 0,
				eta = 0,
				orders = 5,
			}
		}

		ships := make(map[int][]ec.Ship)
		defer delete(ships)

		{
			Ship :: ec.Ship
			// TODO: Do ships need keys? Probably not		
			ships[0] = []Ship{Ship{key = 1, class = 2}, Ship{key = 2, class = 6}}
			ships[1] = []Ship{Ship{key = 3, class = 2}, Ship{key = 4, class = 6}}
			ships[2] = []Ship{Ship{key = 5, class = 1}}
			ships[3] = []Ship{Ship{key = 6, class = 1}}
		}
		
		for key, f in &fleets {
			f.ships = ships[key]
		}
				
		empire.fleets = fleets

		// create empire database
		empire.planet_db = ec.PlanetDB{}
		ec.init_planet_db(&empire.planet_db)

		for key, p in starmap.planets {
			empire.planet_db.year_viewed[key] = -1
			empire.planet_db.year_scouted[key] = -1
			empire.planet_db.pos[key] = p.pos
		}		
	}

	// cleanup database memory
	for _, e in &empires {
		ec.del_planet_db(&e.planet_db)
	}

	fmt.println("done!")

	/* Serialize game data and save to disk */

	game_data := ec.GameData {game_config, starmap, empires}
			
}

init_homeworld :: proc(p: ^ec.Planet, empire: int) {
	p.owner = empire
	p.prev_owner = -1
	p.max_prod = 100
	p.cur_prod = 100
	p.kaspa = 50
	p.armies = 100
	p.ground_batteries = 25
}