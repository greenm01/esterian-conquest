package ec

Message :: struct {
	text: string,
}

serialize_message :: proc(s: ^Serializer, message: ^Message, loc := #caller_location) -> bool {
   	serialize(s, &message.text, loc) or_return
    return true
}