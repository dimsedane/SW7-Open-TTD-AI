import ("pathfinder.road", "RoadPathFinder", 3);
class SW7Pathfinder {
	function connected(tile_id_a, tile_id_b);
}

function SW7Pathfinder::connected(tile_id_a, tile_id_b) {
	local pathfinder = RoadPathFinder();
	pathfinder.InitializePath(tile_id_a, tile_id_b);
	
	local path = false;
	while (!path) {
		path = pathfinder.FindPath(100);
	}
	
	return (path != null);
}