import ("pathfinder.road", "RoadPathFinder", 3);
class SW7Pathfinder {
	/**
	 * Check whether the provided tiles are directly connected by road.
	 */
	function connected(tile_id_a, tile_id_b);
	
	function connect(tile_id_a, tile_id_b); 
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

function SW7Pathfinder::connect(tile_id_a, tile_id_b) {
	AILog.Info("connecting");
	local pathfinder = RoadPathFinder();
	pathfinder.InitializePath([tile_id_a], [tile_id_b]);
	
	local path = false;
	while (!path) {
		path = pathfinder.FindPath(200);
		AIController.Sleep(1);
	}
	
	if (path == null) {
		return false;
	}
	
	while (path != null) {
		local par = path.GetParent();
		if (par != null) {
			local last_node = path.GetTile();
			if (AIMap.DistanceManhattan(path.GetTile(), par.GetTile()) == 1 ) {
				if (!AIRoad.BuildRoad(path.GetTile(), par.GetTile())) {
					/* An error occured while building a piece of road. TODO: handle it. 
					 * Note that is can also be the case that the road was already build. */
				}
			} else {
				/* Build a bridge or tunnel. */
				if (!AIBridge.IsBridgeTile(path.GetTile()) && !AITunnel.IsTunnelTile(path.GetTile())) {
					/* If it was a road tile, demolish it first. Do this to work around expended roadbits. */
					if (AIRoad.IsRoadTile(path.GetTile())) AITile.DemolishTile(path.GetTile());
					if (AITunnel.GetOtherTunnelEnd(path.GetTile()) == par.GetTile()) {
						if (!AITunnel.BuildTunnel(AIVehicle.VT_ROAD, path.GetTile())) {
							/* An error occured while building a tunnel. TODO: handle it. */
						}
					} else {
						local bridge_list = AIBridgeList_Length(AIMap.DistanceManhattan(path.GetTile(), par.GetTile()) + 1);
						bridge_list.Valuate(AIBridge.GetMaxSpeed);
						bridge_list.Sort(AIList.SORT_BY_VALUE, false);
						if (!AIBridge.BuildBridge(AIVehicle.VT_ROAD, bridge_list.Begin(), path.GetTile(), par.GetTile())) {
							/* An error occured while building a bridge. TODO: handle it. */
						}
					}
				}
			}
		}
		path = par;
	}
}