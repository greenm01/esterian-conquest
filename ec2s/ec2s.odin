package ec2s

import "core:fmt"
import "core:os"

import "cli"

main :: proc() {
	cli.parse_args(os.args)
}

