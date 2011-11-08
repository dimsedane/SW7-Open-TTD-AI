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
	local stationLocation = AIStation.GetLocation(Station);
	
	options = TileListGenerator.generateNear(stationLocation, 10);
	
	local ebsbo = null;
	foreach (tile, _ in options) {
		ebsbo = BusStationBuildOrder(tile, Station);
		if (ebsbo.test() != null) {
			break;
		}
		ebsbo = null;
	}
	
	if (ebsbo != null) {
		options = TileListGenerator.generateFlatRoadTilesNear(AITown.GetLocation(town), 5);
		options = SW7MEUP.optimize(options, [ebsbo.tile]);
		local cbsbo = null;
		
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
			
			foreach (tile, front in options) {
				dbo = DepotBuildOrder(tile, front);
				if (dbo.test() != null) {
					break;
				}
				dbo = null;
			}
			
			if (dbo != null) {
				local rbo = RoadBuildOrder(dbo.front, ebsbo.tile);
				if (rbo.test() == null) {
					rbo = null;
				}
				
				if (rbo != null) {
					local engList = SW7MEUP.GetRoadVehicle(SW7MEUP.RV_PARAM_HIGH_CARGO_CAPACITY);
					local vbo = null;
					
					foreach (engL, _ in engList) {
						vbo = VehicleBuildOrder(dbo.location, engL);
						if (vbo.test() != null) {
							break;
						}
						vbo = null;
					}
					
					if (vbo != null) {
						ebsbo.execute();
						cbsbo.execute();
						dbo.execute();
						rbo.execute();
						
						AIRoad.BuildRoad(dbo.location, dbo.front);
						
						vbo.depot = dbo.location;
						local veh = vbo.execute();
						AIOrder.AppendOrder(veh, cbsbo.tile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
						AIOrder.AppendOrder(veh, ebsbo.tile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
						AIVehicle.StartStopVehicle(veh);
						
						return true;
					}
				}
			}
		}
	}
	return false;
}