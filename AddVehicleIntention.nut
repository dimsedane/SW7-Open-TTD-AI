class AddVehicleIntention extends Intention {
	/**
	 * The sw7Town to add a vehicle to.
	 */
	town = null;
	/**
	 * The vehicle to clone
	 */
	veh = null;
	/**
	 * New vehicle.
	 */
	nVeh = null;
	
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
	nVeh = AIVehicle.CloneVehicle(town.Depot, veh, true);
	
	if (!AIVehicle.IsValidVehicle(nVeh)) return false;
	
	AIVehicle.StartStopVehicle(nVeh);
	
	return true;
}

function AddVehicleIntention::PostExecute() {
	town.lastAddVehicle = AIController.GetTick();
	town.AddVehicle(nVeh);
	return true;
}

function AddVehicleIntention::Equals(intention) {
	if (intention instanceof AddVehicleIntention) {
		if (intention.town.TownId == this.town.TownId) return true;
	}
	return false;
}

function AddVehicleIntention::GetCost() {
	return AIEngine.GetPrice(AIVehicle.GetEngineType(veh));
}

function AddVehicleIntention::GetPrio() {
	local ts = town.GetPopulation();
	local vehCount = town.Vehicles.Count();
	local unfed = ts - (vehCount * 800);
	local prio = -1;
	
	if (unfed < 0) {
		prio = -1;
	} else if (unfed <= 16000) {
		prio = ((unfed * 5)/1000).tointeger();
	} else {
		prio = 90;
	}
	
	AILog.Info(town.GetName() + " " + ts + " " + vehCount + " " + unfed + " " + prio);
	
	return prio;
}