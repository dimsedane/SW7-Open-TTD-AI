class FeedStationIntention extends Intention {
	Station = null;
	town = null;
	
	constructor(_station) {
		Station = _station;
		town = AIStation.GetNearestTown(Station);
	}
}

function FeedStationIntention::Execute() {
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
	local loc = AITown.GetLocation(town);
	local firststation = null;
	
	
	if (SW7Pathfinder.connected(loc, loc + AIMap.GetTileIndex(0,4))) {
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
		} else {
			local stationLocation = AIStation.GetLocation(Station);
			local secondstation = null;
			
			for (local i = 0; i < 5; i++) {
				for (local j = 0; j < i; j++) {
					local k = i - j;
					secondstation = stationLocation + AIMap.GetTileIndex(k, j);
					
					if (AIRoad.IsRoadTile(secondstation)) {
						if (!AIRoad.BuildDriveThroughRoadStation(secondstation, secondstation + AIMap.GetTileIndex(1, 0), AIRoad.ROADVEHTYPE_BUS, Station)) {
							if (!AIRoad.BuildDriveThroughRoadStation(secondstation, secondstation + AIMap.GetTileIndex(0, 1), AIRoad.ROADVEHTYPE_BUS, Station)) {
								
							} else {
								return true;
							}
						} else {
							return true;
						}
					}
				}
			}
		}
	}
	
	return true;
}