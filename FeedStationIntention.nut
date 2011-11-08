class FeedStationIntention extends Intention {
	Station = null;
	town = null;
	
	constructor(_station) {
		this.Station = _station;
		this.town = AIStation.GetNearestTown(_station);
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
	
	AILog.Info("Executing FeedStationIntention for station " + AIStation.GetName(Station) + " in " + AITown.GetName(town));
			
	options = TileListGenerator.generateNear(stationLocation, 10);
	
	options.Sort(AIList.SORT_BY_VALUE, true);
	
	local built = false;
	foreach (tile, _ in options) {
		if (!built) {
			built = BuildStation(tile, Station);
			if (built) extendBusStationTile = tile;
		}
	}

	if (built) {
		local tileoptions = TileListGenerator.generateFlatRoadTilesNear(AITown.GetLocation(town), 5);
		
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
			local depottiles = TileListGenerator.generateDepotTiles(town);
			
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
							front = tile + AIMap.GetTileIndex(0, -1);
							break;
						case 2: 
							front = tile + AIMap.GetTileIndex(-1, 0);
							break;
						case 3:
							front = tile + AIMap.GetTileIndex(1, 0);
							break;
					}
					
					if (AITile.GetMinHeight(front) == AITile.GetMaxHeight(front) && AITile.IsBuildable(front)) {
						depotbuild = AIRoad.BuildRoadDepot(tile, front);
					}
				}

				if (depotbuild && depottile == null) {
					depottile = tile;
				}
			}
			
			if (depottile != null && town != null) {
				SW7Pathfinder.connect(depottile, AITown.GetLocation(town));
				
				local engList = SW7MEUP.GetRoadVehicle(SW7MEUP.RV_PARAM_HIGH_CARGO_CAPACITY);
				local eng = engList.Begin();
				
				if (eng != null) {
					local veh = AIVehicle.BuildVehicle(depottile, eng);
					AILog.Info(centreStationTile);
					AIOrder.AppendOrder(veh, centreStationTile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
					AIOrder.AppendOrder(veh, extendBusStationTile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
					
					AIVehicle.StartStopVehicle(veh);
					
					return true;
				} 
			}
		}
	}
	return false;
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