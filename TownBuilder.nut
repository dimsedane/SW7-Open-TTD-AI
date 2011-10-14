class TownBuilder {
	Town = null;
	
	constructor(TownId) {
		Town = SW7Town(TownId);
	}
	
	function Build() {
		AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
		local loc = Town.GetLocation();
		local firststation = null;
		
		if (AIRoad.AreRoadTilesConnected(loc, loc + AIMap.GetTileIndex(0, 1)) && AIRoad.AreRoadTilesConnected(loc + AIMap.GetTileIndex(0, 1), loc + AIMap.GetTileIndex(0, 2)) && AIRoad.AreRoadTilesConnected(loc + AIMap.GetTileIndex(0, 2), loc + AIMap.GetTileIndex(0, 3)) && AIRoad.AreRoadTilesConnected(loc + AIMap.GetTileIndex(0, 3), loc + AIMap.GetTileIndex(0, 4))) {
			if (AIRoad.AreRoadTilesConnected(loc + AIMap.GetTileIndex(0, 4), loc + AIMap.GetTileIndex(1, 4))) {
				firststation = loc + AIMap.GetTileIndex(1, 4);
			} else if (AIRoad.AreRoadTilesConnected(loc + AIMap.GetTileIndex(0, 4), loc + AIMap.GetTileIndex(-1, 4))) {
				firststation = loc + AIMap.GetTileIndex(-1, 4);
			}
		}
		
		if (firststation == null) {
			AILog.Error("Failed building");
			//Build road
		} else {
			if (!AIRoad.BuildDriveThroughRoadStation(firststation, firststation + AIMap.GetTileIndex(1, 0), AIRoad.ROADVEHTYPE_BUS, AIStation.STATION_NEW)) {
				AILog.Error("Attempted, but failed, to build");
			}
		}
		
		BeliefManager.AddServicedTown(Town);
	}
}

//Make station near (loc - (0,5)) & (loc + (0,5))