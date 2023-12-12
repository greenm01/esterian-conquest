package server

import "core:os"
import "core:fmt"
import "core:encoding/json"
import "core:strings"

//import "../ec2/serializer"
//szr :: serializer

create_game :: proc(config_data: json.Value) {
	
	fmt.println("################################")
	fmt.println("##### Creating New EC Game #####")
	fmt.println("################################")

	/* #############################
	   ##### STARMAP & PLANETS #####
	   ############################# */	

	config := config_data.(json.Object)	
	num_players := int(config["num_players"].(json.Float))

	starmap := new_starmap(num_players)
	
	/* #########################
	   ##### EMPIRE SETUP  #####
	   ######################### */

	fmt.print("creating empires...")
	
	empires := make(map[int]Empire)
	defer delete(empires)
	
	// create empires and assign homeworlds
	for hw, i in starmap.homeworlds {
		id := i + 1
		builder := strings.builder_make()
		strings.write_string(&builder, "Rogue ")
		strings.write_int(&builder, id)
		rogue := strings.to_string(builder)
		empires[id] = Empire {
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
		fleets := make(map[int]Fleet)
		defer delete(fleets)
		
		for f := 0; f < 4; f +=1 {
			fleets[f] = Fleet {
				key = f,
				roe = 6,
				speed = 0,
				eta = 0,
				orders = 5,
			}
		}

		ships := make(map[int][]Ship)
		defer delete(ships)

		// TODO: Do ships need keys? Probably not		
		ships[0] = []Ship{Ship{key = 1, class = 2}, Ship{key = 2, class = 6}}
		ships[1] = []Ship{Ship{key = 3, class = 2}, Ship{key = 4, class = 6}}
		ships[2] = []Ship{Ship{key = 5, class = 1}}
		ships[3] = []Ship{Ship{key = 6, class = 1}}

		for key, f in &fleets {
			f.ships = ships[key]
		}
				
		empire.fleets = fleets

		// create empire database
		empire.planet_db = PlanetDB{}
		init_planet_db(&empire.planet_db)

		for key, p in starmap.planets {
			empire.planet_db.year_viewed[key] = -1
			empire.planet_db.year_scouted[key] = -1
			empire.planet_db.pos[key] = p.pos
		}		
	}

	// cleanup database memory
	for _, e in &empires {
		del_planet_db(&e.planet_db)
	}

	fmt.println("done!")

	/* TODO: serialize game data and save to disk */
	//s: szr.Serializer

	//szr.serialize(s, empires[0].planet_db.pos)
			
}


