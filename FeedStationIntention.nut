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
	local options = AITileList();
	local extendBusStationTile = null;
	local centreStationTile = null;
	local stationLocation = AIStation.GetLocation(Station);
			
	for (local i = 0; i < 10; i++) {
		for (local j = 0; j <= i; j++) {
			
			local k = i - j;
			local tmp = stationLocation + AIMap.GetTileIndex(k, j);
			
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, 0);
			}
			tmp = stationLocation + AIMap.GetTileIndex(-k, -j);
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, 0);
			}
			
			tmp = stationLocation + AIMap.GetTileIndex(-k, j);
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, 0);
			}
			
			tmp = stationLocation + AIMap.GetTileIndex(k, -j);
			if (AIRoad.IsRoadTile(tmp)) {
				options.AddItem(tmp, 0);
			}
		}
	}
	
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
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(-1, 4);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(0, 5);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(0, 3);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		
		testtile = loc + AIMap.GetTileIndex(1, -4);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(-1, -4);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(0, -5);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(0, -3);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		
		testtile = loc + AIMap.GetTileIndex(4, 1);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(4, -1);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(5, 0);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(3, 0);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		
		testtile = loc + AIMap.GetTileIndex(-4, 1);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(-4, -1);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(-5, 0);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		testtile = loc + AIMap.GetTileIndex(-3, 0);
		if (check(testtile)) tileoptions.AddItem(testtile, 0);
		
		tileoptions = SW7MEUP.optimize(tileoptions, [extendBusStationTile]);
		
		built = false;
		foreach (tile, _ in tileoptions) {
			if (!built) {
				built = BuildStation(tile, AIStation.STATION_NEW);
			}
			if (built) centreStationTile = tile;
		}
	} else {
		AILog.Error("Failed building station extension.");
		return false;
	}
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