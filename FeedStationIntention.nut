class FeedStationIntention extends Intention {
	Station = null;
	town = null;
	depottile = null;
	veh = null;
	
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
	local boArr = [];
	
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
	local loc = AITown.GetLocation(town);
	
	local options = AITileList();
	local stationLocation = AIStation.GetLocation(Station);
	
	if (!TownIsBuildable()) return false;
	
	options = TileListGenerator.generateNear(stationLocation, 10);
	
	local ebsbo = TestExtensionStationBO(options);
	
	if (ebsbo != null) {
		options = TileListGenerator.generateFlatRoadTilesNear(AITown.GetLocation(town), 5);
		options = SW7MEUP.optimize(options, [ebsbo.tile]);
		local cbsbo = TestCentralStationBO(options);
				
		if (cbsbo != null) {
			options = TileListGenerator.generateDepotTiles(town);
			local dbo = testDBO(options);
			
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
						boArr.append(ebsbo);
						boArr.append(cbsbo);
						boArr.append(dbo);
						boArr.append(rbo);
						boArr.append(vbo);
						
						if (getCost(boArr) > AICompany.GetBankBalance(AICompany.COMPANY_SELF)) {
							return false;
						}
						
						executeBuildOrders(boArr);
						
						if (veh != false) {
							AIOrder.AppendOrder(veh, cbsbo.tile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
							AIOrder.AppendOrder(veh, ebsbo.tile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
							AIVehicle.StartStopVehicle(veh);
						
							return true;
						}
					}
				}
			}
		}
	}
	return false;
}

function FeedStationIntention::TestExtensionStationBO(tilelist) {
	local ebsbo;
	foreach (tile, _ in tilelist) {
		ebsbo = BusStationBuildOrder(tile, Station);
		if (ebsbo.test() != null) {
			return ebsbo;
		}
	}
	return null;
}

function FeedStationIntention::TestCentralStationBO(tilelist) {
	local cbsbo;
	foreach (tile, _ in tilelist) {
		cbsbo = BusStationBuildOrder(tile, AIStation.STATION_NEW);
		if (cbsbo.test() != null) {
			return cbsbo;
		}
	}
	return null;
}

function FeedStationIntention::testDBO(tilelist) {
	local dbo;
	foreach (tile, front in tilelist) {
		dbo = DepotBuildOrder(tile, front);
		if (dbo.test() != null) {
			return dbo;
		}
	}
	
	return null;
}

function getCost(boarr) {
	local cost = 0;
	foreach (bo in boarr) {
		cost += bo.cost;
	}
	
	return cost;
}


function FeedStationIntention::executeBuildOrders(buildOrderArray) {
	foreach (bo in buildOrderArray) {		
		if (bo instanceof DepotBuildOrder) {
			bo.execute();
			depottile = bo.location;
			AIRoad.BuildRoad(bo.location, bo.front);
		} else if (bo instanceof VehicleBuildOrder) {
			bo.depot = depottile;
			
			veh = bo.execute();
		} else {
			bo.execute();
		}		
	}	
}

function FeedStationIntention::TownIsBuildable() {
	switch(AITown.GetRating(town, AICompany.COMPANY_SELF)) {
		case AITown.TOWN_RATING_APPALLING:
		case AITown.TOWN_RATING_VERY_POOR:
			AILog.Info("Town " + town + " rates our company too low. Now we're doomed!");
			return false;
			break;
		case AITown.TOWN_RATING_POOR:
		case AITown.TOWN_RATING_MEDIOCRE:
		case AITown.TOWN_RATING_GOOD:
		case AITown.TOWN_RATING_VERY_GOOD:
		case AITown.TOWN_RATING_EXCELLENT:
		case AITown.TOWN_RATING_OUTSTANDING:
		case AITown.TOWN_RATING_NONE:
			return true;
			break;
		case AITown.TOWN_RATING_INVALID:
			AILog.Error("Invalid town!");
			return false;
			break;
	}
}