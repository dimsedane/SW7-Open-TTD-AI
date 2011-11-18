class DesireManager {
	Desires = {};
	
	constructor () {
		Desires.rawset(Desire.FEED_STATION, Desire(Desire.FEED_STATION));
		Desires.rawget(Desire.FEED_STATION).active = false;
		Desires.rawset(Desire.ECONOMICALLY_RESPONSIBLE, Desire(Desire.ECONOMICALLY_RESPONSIBLE));
		Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active = false;
		Desires.rawset(Desire.EXTEND_FEEDER_NETWORK, Desire(Desire.EXTEND_FEEDER_NETWORK));
		Desires.rawget(Desire.EXTEND_FEEDER_NETWORK).active = false;
		Desires.rawset(Desire.ADD_VEHICLE, Desire(Desire.ADD_VEHICLE));
		Desires.rawget(Desire.ADD_VEHICLE).active = false;
	}
	
	
	function ActivateDesires(bm);
	
	/**
	 * Activate FeedStation Desire for stations it makes sense in.
	 * @param BeliefManager bm Instance of a BeliefManager
	 */
	function ActivateFSDesire(bm);
	
	function ActivateERDesire(bm);
	
	function ActivateEFNDesire(bm);
	
	function ActivateAVDesire(bm);
}

function DesireManager::ActivateDesires(bm) {
	DesireManager.ActivateFSDesire(bm);
	DesireManager.ActivateERDesire(bm);
	DesireManager.ActivateEFNDesire(bm);
	DesireManager.ActivateAVDesire(bm);
}

function DesireManager::ActivateAVDesire(bm) {
	local des = Desire.ADD_VEHICLE;
	local activateDes = false;
	
	foreach (townid, sw7town in bm.AllTownsList.towns) {
		//Check if we need to add additional vehicles here
		//Could be done by using Waiting cargo amount for all stations in question? (AIStation.GetCargoWaiting(stationId) vs. AIVehicle.GetCapacity(vehicleId, cargoId)
		local pax = bm.getPaxCargoId();
		
		local waitingCargo = 0;
		local cargoCapacity = 0;
		
		foreach (station, _ in sw7town.Stations) {
			waitingCargo += AIStation.GetCargoWaiting(station, pax);
		}
		
		foreach (vehicle, _ in sw7town.Vehicles) {
			cargoCapacity += AIVehicle.GetCapacity(vehicle, pax);
		}
		
		if (waitingCargo > (cargoCapacity * 3)) { //For funs - sæt til 3!
			local cTick = AIController.GetTick();
			
			if (bm.LastVehicleCheck == null) {
				bm.LastVehicleCheck = cTick;
				sw7town.setDesire(des, true);
				activateDes = true;
			} else if ((bm.LastVehicleCheck + 50) < cTick) {
				bm.LastVehicleCheck = cTick;
				sw7town.setDesire(des, true);
				activateDes = true;
			}
		}
	}
	
	DesireManager.Desires.rawget(Desire.ADD_VEHICLE).active = activateDes;
}

function DesireManager::ActivateFSDesire(bm) {
	local des = (Desire.FEED_STATION);
	
	if (bm.StationsToFeed.Count() == 0) {
		DesireManager.Desires.rawget(des).active = false;
	} else {
		DesireManager.Desires.rawget(des).active = true;

		foreach (id, town in bm.AllTownsList.towns) {
			if (town.active) {
				if (!bm.CurrentServicedTownsList.rawin(id)) {
					town.setDesire(des, (town.GetPopulation() > 400));
				} else {
					town.setDesire(des, false);
				}
			}
		}
	}
}

function DesireManager::ActivateERDesire(bm) {
	local des = Desire.ECONOMICALLY_RESPONSIBLE;
	if (bm.CurrentMoney > bm.LoanInterval) {
		DesireManager.Desires.rawget(des).active = true;
	} else {
		DesireManager.Desires.rawget(des).active = false;
	}
}

function DesireManager::ActivateEFNDesire(bm) {
	local townsToExtend = false;
	local des = Desire.EXTEND_FEEDER_NETWORK;
	
	foreach (sTown in bm.CurrentServicedTownsList) {
		local popl = sTown.GetPopulation();
		local stMax = (0.00000001 * popl * popl + 0.001 * popl + 2.25)*2/3;
		
		if (stMax >= (sTown.Stations.Count() + 1)) {
			sTown.setDesire(des, true);
			townsToExtend = true;
		} else {
			sTown.setDesire(des, false);
		}
	}
	
	DesireManager.Desires.rawget(des).active = townsToExtend;
}