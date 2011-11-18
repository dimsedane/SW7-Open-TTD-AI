class AddVehicleIntention extends Intention {
	town = null;
	function constructor(sw7town) {
		::Intention.constructor();
		this.prio = this.capPop(sw7town.GetPopulation());
		town = sw7town;
	}
}

function AddVehicleIntention::Execute() {
	local veh = town.Vehicles.Begin();
	local price = AIEngine.GetPrice(AIVehicle.GetEngineType(veh));
	
	if (price > AICompany.GetBankBalance(AICompany.COMPANY_SELF)) {
		AICompany.SetLoanAmount(AICompany.GetMaxLoanAmount());
	}
	local nVeh = AIVehicle.CloneVehicle(town.Depot, veh, true);
	AIVehicle.StartStopVehicle(nVeh);
	
	return true;
}