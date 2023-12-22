package client

import "core:os"
import "core:fmt"
import "core:log"
import "core:net"

import "../ec"

main :: proc() {
	server_connect()	
}

server_connect :: proc() {

	endpoint := net.Endpoint {
		address = net.IP4_Address([4]u8{127, 0, 0, 1}),
		port    = 10000,
	}

	dial_socket, ok := net.dial_tcp(endpoint)
	fmt.println(endpoint.address)
	if ok != nil {
		fmt.printf("error dialing port %d: %v", endpoint.port, ok)
		os.exit(1)
	}
		
	log.infof("Connected to port %d", endpoint.port)

	login := ec.Login {
		"mason",
		"foobar",
	}

	s: ec.Serializer
	ec.serializer_init_writer(&s)
	ec.serialize(&s, &login)

	m := [dynamic]byte{'L'}
	append(&m, ..s.data[:])
	append(&m, '\n')
	fmt.println(m)
	net.send(dial_socket, m[:])

	
}
