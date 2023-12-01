package ec2s

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

	new_starmap(num_players)

}


