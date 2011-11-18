class ExtendNetworkIntention extends Intention {
	sw7town = null;
	bsbo = null;
	
	constructor(sw7town_) {
		::Intention.constructor();
		sw7town = sw7town_;
	}
}

function ExtendNetworkIntention::Test() {
	local searchRadius = 0.0013 * sw7town.GetPopulation() + 6;

	local stationTiles = [];
	local options = TileListGenerator.generateFlatRoadTilesNear(sw7town.GetLocation(), searchRadius);
	foreach (station, _ in sw7town.Stations) {
		stationTiles.append(AIStation.GetLocation(station));
	}
	
	options = SW7MEUP.optimize(options, stationTiles);
	
	bsbo = TestBusStationBO(options);
	
	if (bsbo == null) return false;
	return true;
}

function ExtendNetworkIntention::Execute() {
	local st = null;
	if (bsbo != null) {
		if (bsbo.cost > AICompany.GetBankBalance(AICompany.COMPANY_SELF)) {
			AICompany.SetLoanAmount(AICompany.GetMaxLoanAmount());
		}
		
		st = bsbo.execute();
		if (st != false) {
			sw7town.AddStation(AIStation.GetStationID(st));
			foreach (veh, _ in sw7town.Vehicles) {
				AIOrder.AppendOrder(veh, st, AIOrder.AIOF_NON_STOP_INTERMEDIATE);
			}
			sw7town.lastExtend = AIController.GetTick();
			return true;
		}
	}	
	return false;
}

function ExtendNetworkIntention::TestBusStationBO(tilelist) {
	local bsbo;
	foreach (tile, _ in tilelist) {
		bsbo = BusStationBuildOrder(tile, AIStation.STATION_NEW);
		if (bsbo.test() != null) {
			return bsbo;
		}
	}
	return null;
}

function ExtendNetworkIntention::Equals(intention) {
	if (intention instanceof ExtendNetworkIntention) {
		if (intention.sw7town.TownId == this.sw7town.TownId) return true;
	}
	
	return false;
}

function ExtendNetworkIntention::GetCost() {
	return bsbo.cost;
}

function ExtendNetworkIntention::GetPrio() {
	local ts = sw7town.GetPopulation();
	local tmpPrio = 0;
	local updTime = sw7town.lastExtend;
	
	if (ts < 1000) {
		tmpPrio = ts/100;
	} else if (ts <= 4000) {
		tmpPrio = 0.025 * ts - 15;
	} else {
		tmpPrio = 90;
	}
	
	tmpPrio = tmpPrio * (1/6);
	
	if (updTime = -1) {
		return tmpPrio.tointeger();
	} else {
		local elapsed = AIController.GetTick() - updTime;
		if (elapsed > 5000) {
			return (tmpPrio).tointeger();
		} else {
			return (tmpPrio * elapsed/5000).tointeger();
		}
	}
}