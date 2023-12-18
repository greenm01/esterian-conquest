package server

// https://github.com/GoNZooo/protohackers-stream/blob/main/means_to_an_end/means_to_an_end.odin 

import "core:fmt"
import "core:os"
import "core:net"
import "core:log"
import "core:thread"

import "../ec"

init_server :: proc(config: ec.GameConfig, path: string) {
	fmt.print("starting game daemon...")
	
	endpoint := net.Endpoint {
		address = net.IP4_Address([4]u8{0, 0, 0, 0}),
		port    = config.port,
	}

	listen_socket, ok := net.listen_tcp(endpoint)
	if ok != nil {
		fmt.printf("Error listening on port %d: %v", config.port, ok)

		os.exit(1)
	}

	log.infof("Listening on port %d", config.port)

	thread_pool: thread.Pool
	thread.pool_init(&thread_pool, context.allocator, 100)
	thread.pool_start(&thread_pool)

	game_data := load_game_data(path)
	
	fmt.println("done!")
}
