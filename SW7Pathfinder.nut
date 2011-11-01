import ("pathfinder.road", "RoadPathFinder", 3);
class SW7Pathfinder {
	/**
	 * Check whether the provided tiles are directly connected by road.
	 */
	function connected(tile_id_a, tile_id_b);
}

function SW7Pathfinder::connected(tile_id_a, tile_id_b) {
	local pathfinder = RoadPathFinder();
	pathfinder.InitializePath([tile_id_a], [tile_id_b]);
	
	// pathfinder.cost.max_cost is 2000000000 - thus no paths, where road-building is necessary, will be returned.
	pathfinder.cost.no_existing_road 	= 2000000001; 
	
	local path = false;
	while (!path) {
		path = pathfinder.FindPath(200);
		AIController.Sleep(1);
	}
	
	return (path != null);
}

