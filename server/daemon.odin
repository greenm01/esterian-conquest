package server

// https://github.com/GoNZooo/protohackers-stream/blob/main/means_to_an_end/means_to_an_end.odin 

import "core:fmt"
import "core:os"
import "core:net"
import "core:log"
import "core:thread"
import "core:mem"
import "core:mem/virtual"

import "../ec"

/* #### MESSAGE FORMAT ####

Byte: |  0  | end  |
Type: |char | data |

The first byte of a message is a charavter indicating the type. This will
be an ASCII uppercase:

L = Login
J = Join Game (new player)
C = Command (fleet, planet, general orders, etc...)
M = Message (send player message)

The remaining bytes are serialized data that will be decoded based on the
type of message.

Insipred by:
	https://github.com/GoNZooo/protohackers-stream/tree/main/means_to_an_end
	https://protohackers.com/problem/2

*/

ClientData :: struct {
	endpoint:  net.Endpoint,
	socket:    net.TCP_Socket,
}

init_server :: proc(config: ec.GameConfig, path: string) {

	//method := ssl.server_method()			
	//fmt.print("starting game daemon...")
	
	endpoint := net.Endpoint {
		address = net.IP4_Address([4]u8{127, 0, 0, 1}),
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

	//game_data := load_game_data(path)
	
	for {
		client_socket, client_endpoint, accept_error := net.accept_tcp(listen_socket)
		if accept_error != nil {
			log.errorf("Error accepting connection: %v", accept_error)
			continue
		}
		log.debugf("Accepted connection: %d (%v)", client_socket, client_endpoint)
		fmt.println("accepted connection")
		
		client_arena: virtual.Arena
		arena_allocator_error := virtual.arena_init_growing(&client_arena, 1 * mem.Kilobyte)
		if arena_allocator_error != nil {
			log.errorf("Error initializing client arena: %v", arena_allocator_error)
			net.close(client_socket)
			continue
		}
		client_allocator := virtual.arena_allocator(&client_arena)
		client_data, client_data_allocator_error := new(ClientData, client_allocator)
		if client_data_allocator_error != nil {
			log.errorf("Error allocating client data: %v", client_data_allocator_error)
			net.close(client_socket)
			continue
		}
		client_data.endpoint = client_endpoint
		client_data.socket = client_socket
		thread.pool_add_task(&thread_pool, client_allocator, handle_client, client_data)
	}
		
	fmt.println("done!")
}

handle_client :: proc(t: thread.Task) {
	client_data := cast(^ClientData)t.data
	context.logger = log.create_console_logger(ident = fmt.tprintf("%v", client_data.endpoint))
	
	log.debugf("Handling client: %v (%v)", client_data.endpoint, client_data)

	for {
		message, done, receive_error := receive_message(client_data.socket)
		if receive_error != nil {
			log.errorf("Error receiving message: %v", receive_error)
			break
		}
		if done {
			log.infof("Client disconnected: %v", client_data.endpoint)
			break
		}

		send_buffer: [4]byte
		outgoing_message := handle_message(message, send_buffer[:])
		if outgoing_message != nil {
			log.debugf("Sending message: %s (%d)", outgoing_message, transmute(i32be)send_buffer)
			sent_bytes, send_error := net.send_tcp(client_data.socket, outgoing_message)
			if send_error != nil {
				log.errorf("Error sending message: %v", send_error)
				break
			}
			if sent_bytes != len(outgoing_message) {
				log.errorf(
					"Error sending message: sent %d bytes, expected to send %d bytes",
					sent_bytes,
					len(outgoing_message),
				)
				break
			}
		}
	}

	net.close(client_data.socket)
}

receive_message :: proc(
	socket: net.TCP_Socket,
) -> (
	message: ec.ClientMessage,
	done: bool,
	error: net.Network_Error,
) {
	bytes: [dynamic]byte
	for {
		buffer: [16]byte
		n, recv_error := net.recv_tcp(socket, buffer[:])
		if n == 0 do return nil, true, nil
		if recv_error == net.TCP_Recv_Error.Timeout do continue
		else if recv_error != nil {
			log.errorf("Error receiving message: %v", recv_error)
			return nil, true, recv_error
		}
		append(&bytes,..buffer[:n])
		// end of message
		if buffer[n-1] == '\n' {
			pop (&bytes)           // remove the newline   
			break
		}		
	}
	return parse_message(bytes[:]), done, nil
}

/* Player sends login info, and if they're a new or unregistered player
 * then we send them basic gamestate info to browse the game. Otherwise 
 * we look up the player and send back their empire data.
*/
parse_message :: proc(buffer: []byte) -> (message: ec.ClientMessage) {
	identifying_byte := buffer[0]
	s: ec.Serializer
	ec.serializer_init_reader(&s, buffer[1:])
	switch identifying_byte {
	case 'L':
		login: ec.Login
		ec.serialize(&s, &login)
		fmt.println("hello", login.player, "pw =", login.password)
		message = login
	case 'C':
		message = ec.Command {
			command = "foo",
		}
	}

	return message
}

handle_message :: proc(
	message: ec.ClientMessage,
	send_buffer: []byte,
) -> (
	outgoing_message: []byte,
) {
	switch m in message {
	case ec.Login:
		fmt.println("Client joined:", m.player)
		return nil
	case ec.Command:
		return send_buffer
	case ec.Query:
		return send_buffer
	}

	return nil
}
