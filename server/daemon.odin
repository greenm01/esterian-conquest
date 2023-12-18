package server

import "core:fmt"
import "core:os"
import "vendor:ENet"
import "../ec"

en :: ENet

init_server :: proc(config: ec.GameConfig) {

	fmt.print("starting game daemon...")

	if en.initialize() != 0 {
		fmt.println("An error occurred while initializing ENet")
		os.exit(1)
	}

	address := en.Address {en.HOST_ANY, u16(config.port)}
	host := en.host_create(&address, 32, 2, 0, 0)
	if host == nil {
		fmt.println("An error occurred while trying to create an ENet server host")
		os.exit(1)
	}
	
	en.host_destroy(host)
	en.deinitialize()

	fmt.println("done!")
		
}
