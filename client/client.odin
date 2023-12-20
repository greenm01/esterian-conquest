package client

import "core:os"
import "core:fmt"
import "core:log"
import "core:net"

main :: proc() {
	server_connect()	
}

server_connect :: proc() {

	endpoint := net.Endpoint {
		address = net.IP4_Address([4]u8{0, 0, 0, 0}),
		port    = 1992,
	}

	dial_socket, ok := net.dial_tcp_from_endpoint(endpoint)
	if ok != nil {
		fmt.printf("Error listening on port %d: %v", endpoint.port, ok)
		os.exit(1)
	}

	log.infof("Listening on port %d", endpoint.port)
}
