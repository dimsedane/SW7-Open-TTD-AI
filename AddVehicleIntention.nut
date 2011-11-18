class AddVehicleIntention extends Intention {
	town = null;
	veh = null;
	function constructor(sw7town) {
		::Intention.constructor();
		town = sw7town;
	}
}

function AddVehicleIntention::Test() {
	veh = town.Vehicles.Begin();
	if (veh == null) return false;
	return AIRoad.IsRoadDepotTile(town.Depot);
}

function AddVehicleIntention::Execute() {
	if (GetCost() > AICompany.GetBankBalance(AICompany.COMPANY_SELF)) {
		AICompany.SetLoanAmount(AICompany.GetMaxLoanAmount());
	}
	local nVeh = AIVehicle.CloneVehicle(town.Depot, veh, true);
	AIVehicle.StartStopVehicle(nVeh);
	
	town.lastAddVehicle = AIController.GetTick();
	return true;
}

function AddVehicleIntention::Equals(intention) {
	if (intention instanceof FeedStationIntention) {
		if (intention.town.TownId == this.town.TownId) return true;
	}
	return false;
}

function AddVehicleIntention::GetCost() {
	return AIEngine.GetPrice(AIVehicle.GetEngineType(veh));
}

function AddVehicleIntention::GetPrio() {
	local ts = town.GetPopulation();
	local tmpPrio = 0;
	local updTime = town.lastAddVehicle;
	
	if (ts < 1000) {
		tmpPrio = ts*0.001;
	} else if (ts <= 4000) {
		tmpPrio = 0.025 * ts - 15;
	} else {
		tmpPrio = 90;
	}
	tmpPrio = (1/3) * tmpPrio;
	
	if (updTime = -1) {
		return tmpPrio.tointeger();
	} else {
		local elapsed = AIController.GetTick() - updTime;
		if (elapsed > 15000) {
			return (tmpPrio).tointeger();
		} else {
			return (tmpPrio * elapsed/15000).tointeger();
		}
	}
}