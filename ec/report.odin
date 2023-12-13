package ec

Report :: struct {
	text: string,
}

serialize_report :: proc(s: ^Serializer, report: ^Report, loc := #caller_location) -> bool {
    serialize(s, &report.text, loc) or_return
    return true
}