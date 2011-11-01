class FeedStationIntention extends Intention {
	Station = null;
	town = null;
	
	constructor(_station) {
		Station = _station;
		town = AIStation.GetNearestTown(Station);
	}
	
    /** 
	 * Execute the intention.
	 * Returns whether the execution succeeded.
	 */
	function Execute();
	
	/**
	 * Attempt to build a Drive Through Bus Station at the provided tile, linked with the given station.
	 * (If a new station should be built, use AIStation.STATION_NEW as second parameter.)
	 */
	function BuildStation(tile, _stat);
}

function FeedStationIntention::Execute() {
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
	local loc = AITown.GetLocation(town);
	
	local options = AITileList();
	local extendBusStationTile = null;
	local centreStationTile = null;
	local stationLocation = AIStation.GetLocation(Station);
			
	for (local i = 1; i < 10; i++) {
		for (local j = 0; j <= i; j++) {
			
			local k = i - j;
			local tmp = stationLocation + AIMap.GetTileIndex(k, j);
			
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, i);
			}
			tmp = stationLocation + AIMap.GetTileIndex(-k, -j);
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, i);
			}
			
			tmp = stationLocation + AIMap.GetTileIndex(-k, j);
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, i);
			}
			
			tmp = stationLocation + AIMap.GetTileIndex(k, -j);
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, i);
			}
		}
	}
	
	options.Sort(AIList.SORT_BY_VALUE, true);
	
	local built = false;
	foreach (tile, _ in options) {
		if (!built) {
			built = BuildStation(tile, Station);
			if (built) extendBusStationTile = tile;
		}
	}

	if (built) {
		local tileoptions = AITileList();
		local testtile = loc + AIMap.GetTileIndex(1, 4);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(-1, 4);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(0, 5);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(0, 3);
		if (check(testtile)) tileoptions.AddTile(testtile);
		
		testtile = loc + AIMap.GetTileIndex(1, -4);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(-1, -4);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(0, -5);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(0, -3);
		if (check(testtile)) tileoptions.AddTile(testtile);
		
		testtile = loc + AIMap.GetTileIndex(4, 1);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(4, -1);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(5, 0);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(3, 0);
		if (check(testtile)) tileoptions.AddTile(testtile);
		
		testtile = loc + AIMap.GetTileIndex(-4, 1);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(-4, -1);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(-5, 0);
		if (check(testtile)) tileoptions.AddTile(testtile);
		testtile = loc + AIMap.GetTileIndex(-3, 0);
		if (check(testtile)) tileoptions.AddTile(testtile);
		
		tileoptions = SW7MEUP.optimize(tileoptions, [extendBusStationTile]);
		
		built = false;
		foreach (tile, val in tileoptions) {
			if (!built) {
				built = BuildStation(tile, AIStation.STATION_NEW);
			}
			if (built && centreStationTile == null) {
				centreStationTile = tile;
			}
		}
		
		//Build depot
		if (centreStationTile != null && extendBusStationTile != null) {
			local depottiles = AITileList();
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(14, 1), 1);
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(14, -1), 0);
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-14, 1), 1);
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-14, -1), 0);
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(1, 14), 2);
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(1, -14), 2);
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-1, 14), 3);
			depottiles.AddItem(AITown.GetLocation(town) + AIMap.GetTileIndex(-1, -14), 3);
			
			local depotbuild = false;
			local depottile = null;
			foreach (tile, dir in depottiles) {
				if (!depotbuild) {
					local front = null;
					switch (dir) {
						case 0:
							front = tile + AIMap.GetTileIndex(0, 1);
							break;
						case 1:
							front = tile - AIMap.GetTileIndex(0, 1);
							break;
						case 2: 
							front = tile - AIMap.GetTileIndex(1, 0);
							break;
						case 3:
							front = tile + AIMap.GetTileIndex(1, 0);
							break;
					}
					
					if (AITile.GetMinHeight(front) == AITile.GetMaxHeight(front)) {
						depotbuild = AIRoad.BuildRoadDepot(tile, front);
					}
				}

				if (depotbuild && depottile == null) {
					depottile = tile;
				}
			}
			
			SW7Pathfinder.connect(depottile, AITown.GetLocation(town));
			
			local engList = AIEngineList(AIVehicle.VT_ROAD);
			local eng = null;
			foreach (engine, _ in engList) {
				if (AIEngine.GetCargoType(engine) == SW7MEUP.getPaxCargoId()) {
					eng = engine;
					break;
				}
			}
			
			if (eng != null) {
				local veh = AIVehicle.BuildVehicle(depottile, eng);
				AILog.Info(centreStationTile);
				AIOrder.AppendOrder(veh, centreStationTile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
				AIOrder.AppendOrder(veh, extendBusStationTile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
				
				AIVehicle.StartStopVehicle(veh);
			}
		}
		
		//Build Road Vehicle
		//Create order list
		//Assign order list
		//Start vehicle
		
	} else {
		AILog.Error("Failed building station extension.");
		return false;
	}
	return true;
}

function FeedStationIntention::BuildStation(tile, _stat) {
	if (!AIRoad.BuildDriveThroughRoadStation(tile, tile + AIMap.GetTileIndex(1, 0), AIRoad.ROADVEHTYPE_BUS, _stat)) {
		if (AIRoad.BuildDriveThroughRoadStation(tile, tile + AIMap.GetTileIndex(0, 1), AIRoad.ROADVEHTYPE_BUS, _stat)) {
			return true;
		}
	} else {
		return true;
	}
	return false;
}

function check(tile) {
	return (AIRoad.IsRoadTile(tile) && (AITile.GetMinHeight(tile) == AITile.GetMaxHeight(tile)));
}