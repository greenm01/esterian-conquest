package ec2s

import "core:fmt"
import "core:os"
import "core:math"

MAX_PRODUCTION :: 150
MIN_PRODUCTION :: 10

StarMap :: struct {
	planets: map[int]Planet,
	grid_size: int,
	systems: [dynamic]int,
	homeworlds: [dynamic]int,
}

// Return x,y grid coordinates of cell number
// Cell 1 starts at (0,0)
grid_pos :: proc(c: int, grid: int) -> (int, int) {
	return (c - 1) % grid, (c - 1) / grid
}

// Return the cell number of given x,y coordinates
// (0,0) starts at cell 1
cell_pos :: proc(grid: int, x: int, y: int) -> int {
	return grid*y + x + 1
}

new_starmap :: proc(num_players: int) -> StarMap {
	
	fmt.println("generating starmap...")

	// Classic EC starmap size bound by number of players:
	// [4:18x18, 9:27x27, 16:36x36, 25:45x45]
	// Nonlinar power regression gives us a nice distribution
	// f(x) = 9*x^(-0.5)
	// https://www.desmos.com/calculator/9itjhjdmig
	r := 9 * math.pow_f32(f32(num_players), 0.5)
	grid_size := int(math.ceil_f32(r))

	fmt.println("Grid Size = ", grid_size)
	
	star_map := StarMap{}
	return star_map
	
}