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
	
	local ebsbo = null;
	local cbsbo = null;
	foreach (tile, _ in options) {
		ebsbo = BusStationBuildOrder(tile, Station);
		if (ebsbo.test() != null) {
			break;
		}
		ebsbo = null;
	}
	
	if (ebsbo != null) {
		extendBusStationTile = ebsbo.tile;
	
		options = TileListGenerator.generateFlatRoadTilesNear(AITown.GetLocation(town), 5);
		options = SW7MEUP.optimize(options, [extendBusStationTile]);
		
		foreach (tile, _ in options) {
			cbsbo = BusStationBuildOrder(tile, AIStation.STATION_NEW);
			if (cbsbo.test() != null) {
				break;
			}
			cbsbo = null;
		}
		
		if (cbsbo != null) {
			options = TileListGenerator.generateDepotTiles(town);
			local dbo = null;
			local depottile = null;
			
			foreach (tile, front in options) {
				dbo = DepotBuildOrder(tile, front);
				if (dbo.test() != null) {
					break;
				}
				dbo = null;
			}

			extendBusStationTile = ebsbo.execute();
			centreStationTile = cbsbo.execute();
			depottile = dbo.execute();
		
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