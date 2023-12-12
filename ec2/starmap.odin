package ec2

import "core:fmt"
import "core:os"
import "core:math"
import "core:math/rand"

MAX_PRODUCTION :: 150
MIN_PRODUCTION :: 10

StarMap :: struct {
	planets: map[int]Planet,
	grid_size: int,
	systems: []int,
	homeworlds: []int,
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
