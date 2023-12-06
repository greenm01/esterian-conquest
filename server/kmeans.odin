package server

import "core:math/rand"
import "core:fmt"
import "core:os"

// k-means clustering to find homeworlds
// ported from the golang: https://github.com/mash/gokmeans

// Node represents an observation of floating point values
Node :: [2]f64

// k-means clustering (LLoyd's algo) to find optimal
// distribution of homeworlds.
k_means :: proc(sys: []Node, num_planets: int, gs: f64) -> [][2]int {

	// Get a list of centroid clusters
	fail, centroids := train(sys, num_planets, 50)
	if !fail {
		fmt.print("K-means clustering failed!\n")
		os.exit(1)
	}
	
	home_worlds := make([][2]int, num_planets)
	for cent, i in centroids {
		home_worlds[i] = [2]int{int(cent[0]), int(cent[1])}
	}

	return home_worlds

}

// Train takes an array of Nodes (observations), and produces as many centroids as specified by
// clusterCount. It will stop adjusting centroids after maxRounds is reached. If there are less
// observations than the number of centroids requested, then Train will return (false, nil).
train :: proc(nodes: []Node, cluster_count: int, max_rounds: int) -> (bool, []Node) {
	if len(nodes) < cluster_count {
		return false, nil
	}

	centroids := make([]Node, cluster_count)

	r: rand.Rand
	rand.init_as_system(&r)

	// Pick centroid starting points from Nodes
	for i := 0; i < cluster_count; i += 1 {
		src_index := rand.int_max(len(nodes), &r)
		centroids[i] = nodes[rand.int_max(len(nodes), &r)]
	}

	return train2(nodes, cluster_count, max_rounds, centroids)

}

// Provide initial centroids
train2 :: proc(nodes: []Node, cluster_count: int, 
			   max_rounds: int, centroids: []Node) -> (bool, []Node) {
	// Train centroids
	
	movement := true
	for i := 0; i < max_rounds && movement; i += 1 {
		movement = false

		groups := make(map[int][dynamic]Node)
		defer delete(groups)

		for node, i in nodes {
			near := k_nearest(node, centroids)
			if groups[near] == nil {
				n := make([dynamic]Node,1)
				n[0] = node
				groups[near] = n
			} else {
				append(&groups[near],node)	
			}
		}
			
		for key, group in groups {
			new_node := mean_node(group)
			if !k_equal(centroids[key], new_node) {
				centroids[key] = new_node
				movement = true
			}
		}
	}
		
	return true, centroids
}

// equal determines if two nodes have the same values.
k_equal :: proc(node1, node2: Node) -> bool {
	if len(node1) != len(node2) {
		return false
	}

	for v, i in node1 {
		if v != node2[i] {
			return false
		}
	}

	return true
}

// Nearest return the index of the closest centroid from nodes
k_nearest :: proc(in_n: Node, nodes: []Node) -> int {

	results := make([]f64, len(nodes))
	defer delete(results)
	
	for node, i in nodes {
		results[i] = k_distance(in_n, node)
	}

	mindex := 0
	curdist := results[0]

	for dist, i in results {
		if dist < curdist {
			curdist = dist
			mindex = i
		}
	}

	return mindex
}

// Distance determines the square Euclidean distance between two nodes
k_distance :: proc(node1: Node, node2: Node) -> f64 {
	squares: Node
	
	for _, i in node1 {
		diff := node1[i] - node2[i]
		squares[i] = diff * diff
	}

	sum := 0.0
	for val, _ in squares {
		sum += val
	}

	return sum
}

// meanNode takes an array of Nodes and returns a node which represents the average
// value for the provided nodes. This is used to center the centroids within their cluster.
mean_node :: proc(values: [dynamic]Node) -> Node {
	new_node: Node

	for value, _ in values {
		for j := 0; j < len(new_node); j += 1 {
			new_node[j] += value[j]
		}
	}

	for value, i in new_node {
		new_node[i] = value / f64(len(values))
	}

	return new_node
}
