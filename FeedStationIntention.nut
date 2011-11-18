class FeedStationIntention extends Intention {
	Station = null;
	town = null;
	depottile = null;
	veh = null;
	boArr = null;
	
	constructor(_station) {
		::Intention.constructor();
		this.Station = _station;
		this.town = TownList.towns.rawget(AIStation.GetNearestTown(_station));
	}
	
    /** 
	 * Execute the intention.
	 * Returns whether the execution succeeded.
	 */
	function Execute();
}

function FeedStationIntention::Test() {
	if (!TownIsBuildable()) return false;
	
	boArr = [];
	local options = AITileList();
	
	options = TileListGenerator.generateNear(AIStation.GetLocation(Station), 10);
	
	local ebsbo = TestExtensionStationBO(options);
	
	if (ebsbo == null) return false;
	options = TileListGenerator.generateFlatRoadTilesNear(town.GetLocation(), 5);
	options = SW7MEUP.optimize(options, [ebsbo.tile]);
	local cbsbo = TestCentralStationBO(options);
	
	if (cbsbo == null) return false;
	options = TileListGenerator.generateDepotTiles(town.TownId);
	local dbo = testDBO(options);
	
	if (dbo == null) return false;
	local rbo = RoadBuildOrder(dbo.front, ebsbo.tile);
	if (rbo.test() == null) return false;
	
	local engList = SW7MEUP.GetRoadVehicle(SW7MEUP.RV_PARAM_HIGH_CARGO_CAPACITY);
	local vbo = TestVehicleBO(dbo.location, engList);
	if (vbo == null) return false;
	
	boArr.append(ebsbo);
	boArr.append(cbsbo);
	boArr.append(dbo);
	boArr.append(rbo);
	boArr.append(vbo);
	
	return true;
}

function FeedStationIntention::Execute() {
	if (getCost() > AICompany.GetBankBalance(AICompany.COMPANY_SELF)) {
		AICompany.SetLoanAmount(AICompany.GetMaxLoanAmount());
	}
	
	executeBuildOrders(boArr);
	town.AddStation(AIStation.GetStationID(boArr[0].tile));
	town.AddStation(AIStation.GetStationID(boArr[1].tile));
	town.setDepot(boArr[2].location);
	
	if (veh != false) {
		town.AddVehicle(veh);
		AIOrder.AppendOrder(veh, boArr[1].tile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
		AIOrder.AppendOrder(veh, boArr[0].tile, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
		AIVehicle.StartStopVehicle(veh);
	
		return true;
	} else {
		AILog.Info("Vehicle not created.");
		return false;
	}
}

function FeedStationIntention::TestVehicleBO(dptile, engL) {
	foreach (engL, _ in engL) {
		local vbo = VehicleBuildOrder(dptile, engL);
		if (vbo.test() != null) {
			return vbo;
		}
		vbo = null;
	}
	return vbo;
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

function getCost() {
	local cost = 0;
	foreach (bo in boArr) {
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
	switch(AITown.GetRating(town.TownId, AICompany.COMPANY_SELF)) {
		case AITown.TOWN_RATING_APPALLING:
		case AITown.TOWN_RATING_VERY_POOR:
			AILog.Info("Town " + town.TownId + " rates our company too low. Now we're doomed!");
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

function FeedStationIntention::Equals(intention) {
	if (intention instanceof FeedStationIntention) {
		if (intention.town.TownId == this.town.TownId) return true;
	}
	return false;
}

function FeedStationIntention::GetPrio() {
	local ts = town.GetPopulation();
	
	if (ts < 1000) {
		return (ts/100).tointeger();
	} else if (ts <= 4000) {
		return (0.025 * ts - 15).tointeger();
	} else {
		return 90;
	}
}