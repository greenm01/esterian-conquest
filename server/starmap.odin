package server

import "core:fmt"
import "core:os"
import "core:math"

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

new_starmap :: proc(num_players: int) -> StarMap {
	
	fmt.print("generating starmap...")

	// Classic EC starmap size bound by number of players:
	// [4:18x18, 9:27x27, 16:36x36, 25:45x45]
	// Nonlinar power regression gives us a nice distribution
	// f(x) = 9*x^(-0.5)
	// https://www.desmos.com/calculator/9itjhjdmig
	r := 9 * math.pow_f32(f32(num_players), 0.5)
	grid_size := int(math.ceil_f32(r))

	// Generate starmap based on a random Poisson distribution
	// This generates a much nicer distribution over a pure random set
	// http://devmag.org.za/2009/05/03/poisson-disk-sampling/
	// Minimum distance between systems is PI. Why not?

	/* TODO: Consider adding perlin noise to distribution */

	starmap := StarMap{}

	gs := f64(grid_size)
	// TODO: optomize this function
	points := poisson_sample(0.0, 0.0, gs, gs, math.PI, 50)
	defer delete(points)

	nodes := make([]Node,len(points))
	defer delete(nodes)

	starmap.systems = make([]int, len(nodes) + num_players)

	for p, i in points {
		nodes[i] = Node{p.x, p.y}
		c := cell_pos(grid_size, int(p.x), int(p.y))
		starmap.systems[i] = c
	}

	fmt.println("done!")
	fmt.print("Finding homeworlds...")
	
	starmap.homeworlds = make([]int, num_players)
	for count := 1; count < 11; count += 1 {
		hw := k_means(nodes, num_players, gs)
		for h, i in hw {
			starmap.homeworlds[i] = cell_pos(grid_size, h[0], h[1])
		}
		
		// Make sure we have a unique set
		if count_duplicates(starmap.homeworlds) == 0 {
			break
		}
		
		if count == 10 {
			fmt.println("Error resolving homeworlds! Try fewer players.")
			os.exit(1)
		}
		
	}

	{
		// add homeworlds to systems
		j := 0
		for i := len(nodes); i < len(starmap.systems); i += 1 {
			starmap.systems[i] = starmap.homeworlds[j]
			j += 1
		}
		// remove duplicates
		starmap.systems = remove_duplicates(starmap.systems)
	}

	fmt.println("done!")
	return starmap
	
}

count_duplicates :: proc(dups: []int) -> int {
	dup_size := len(dups)
	dup_count := 0
	for i := 0; i < dup_size; i += 1 {
		for j := i + 1; j < dup_size; j += 1{
			if dups[i] == dups[j] {
				dup_count += 1
				break
			}
		}
	}
	return dup_count
}

remove_duplicates :: proc(elements: []int) -> []int {
	// Use map to record duplicates as we find them.
	encountered := map[int]bool{}
	defer delete(encountered)
	
	result := [dynamic]int{}
	
	for v, _ in elements {
		if encountered[v] == true {
			// Do not add duplicate.
		} else {
			// Record this element as an encountered element.
			encountered[v] = true
			// Append to result slice.
			append(&result, v)
		}
	}
	// Return the new slice.
	return result[:]
}