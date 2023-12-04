package server

import "core:math/rand"
import "core:math"
import "core:fmt"

// Ported from https://github.com/fogleman/poissondisc
// Sample produces points via Poisson-disc sampling.
// The points will all be within the box defined by `x0`, `y0`, `x1`, `y1`.
// No two points will be closer than the defined radius `r`.
// For each point, the algorithm will make `k` attempts to place a
// neighboring point. Increase this value for a better sampling or decrease
// it to reduce algorithm runtime.
// You may provide your own `*rand.Rand` instance or `nil` to have one
// created for you.
// Learn more about Poisson-disc sampling from the links below:
// https://www.jasondavies.com/poisson-disc/
// https://bl.ocks.org/mbostock/dbb02448b0f93e4c82c3

Point :: struct {
	x, y: f64,
}

distance :: proc(p: Point, q: Point) -> f64 {
	return math.hypot_f64(q.x-p.x, q.y-p.y)
}

poisson_sample :: proc (x0, y0, x1, y1, r: f64, k: int) -> [dynamic]Point {

	my_rand: rand.Rand
	rand.init_as_system(&my_rand)

	result: [dynamic]Point
	active: [dynamic]Point
	grid := new_grid(x0, y0, x1, y1, r)
	
	defer delete(grid.cells)
	defer delete (active)
	
	// add the first point
	{
		x := rand.float64_range(x0, x1, &my_rand)
		y := rand.float64_range(y0, y1, &my_rand)
		p := Point{x, y}
		insert_point(&grid, p)
		append(&active, p)
		append(&result, p)
	}
	
	// try to add points until no more are active
	for len(active) > 0 {
		// pick a random active point
		index := rand.int_max(len(active), &my_rand)
		point := active[index]
		ok := false

		// make k attempts to place a nearby make_multi_pointer
		for i := 0; i < k; i += 1 {
			a := rand.float64(&my_rand) * 2 * math.PI
			d := r * math.sqrt_f64(rand.float64(&my_rand) * 3 + 1)
			x := point.x + math.cos_f64(a)*d
			y := point.y + math.sin_f64(a)*d
			if x < x0 || y < y0 || x > x1 || y > y1 {
				continue
			}
			p := Point{x, y}
			if !insert_point(&grid, p) {
				continue
			}
			append(&result, p)
			append(&active, p)
			ok = true
			break
		}

		// make this point inactive if we failed to add a new point
		if !ok {
			active[index] = active[len(active)-1]
			pop(&active)
			//active = active[:len(active)-1]
		}
	}
	
	return result
	
}

Grid :: struct {
	radius: f64,
	size: f64,
	gw, gh: int,
	i0, j0: int,
	cells:  []Point,
}

sentinel :: Point{math.NEG_INF_F64, math.NEG_INF_F64}

new_grid :: proc(x0, y0, x1, y1, r: f64) -> Grid {
	
	size := r / math.sqrt_f64(2)

	i0 := int(math.floor_f64(x0 / size))
	j0 := int(math.floor_f64(y0 / size))
	i1 := int(math.floor_f64(x1 / size))
	j1 := int(math.floor_f64(y1 / size))

	gw := i1 - i0 + 1
	gh := j1 - j0 + 1
	cells := make([]Point, gw*gh) 
	
	for _, i in cells {
		cells[i] = sentinel
	}

	return Grid{r, size, gw, gh, i0, j0, cells}

}

insert_point :: proc(g: ^Grid, p: Point) -> bool {
	ci := int(math.floor_f64(p.x/g.size)) - g.i0
	cj := int(math.floor_f64(p.y/g.size)) - g.j0

	q := g.cells[cj*g.gw+ci]
	if q != sentinel && distance(p, q) < g.radius {
		return false
	}

	i0 := max(0, ci-2)
	j0 := max(0, cj-2)
	i1 := min(g.gw, ci+3)
	j1 := min(g.gh, cj+3)

	for j := j0; j < j1; j += 1 {
		for i := i0; i < i1; i += 1 {
			q := g.cells[j*g.gw+i]
			if q != sentinel && distance(p, q) < g.radius {
				return false
			}
		}
	}

	g.cells[cj*g.gw+ci] = p
	return true
}
