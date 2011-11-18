class ExtendNetworkIntention extends Intention {
	sw7town = null;
	
	constructor(sw7town_) {
		::Intention.constructor();
		sw7town = sw7town_;
		this.prio = this.capPop(sw7town.GetPopulation());
	}
}

function ExtendNetworkIntention::Execute() {
	local searchRadius = 0.0013 * sw7town.GetPopulation() + 6;
	
	local stationTiles = [];
	local options = TileListGenerator.generateFlatRoadTilesNear(sw7town.GetLocation(), searchRadius);
	foreach (station, _ in sw7town.Stations) {
		stationTiles.append(AIStation.GetLocation(station));
	}
	
	options = SW7MEUP.optimize(options, stationTiles);
	
	local bsbo = TestBusStationBO(options);
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