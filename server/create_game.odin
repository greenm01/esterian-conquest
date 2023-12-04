package server

import "core:os"
import "core:fmt"
import "core:encoding/json"

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
	   ##### PLAYER SETUP  #####
	   ######################### */

	/*	## Assign fleets #####################################
	   	# Per classic EC, each empire get 4 starting fleets: #
	   	# - Two Fleets with one ETAC and a Cruiser escort    #
	   	# - Two Fleets with one Destroyers                   #
	   	# - Orders are to guard/blockade homeworld           #
			######################################################
	*/


	
}


