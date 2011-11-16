class AddVehicleIntention extends Intention {
	town = null;
	function constructor(sw7town) {
		town = sw7town;
	}
}

function AddVehicleIntention::Execute() {
	AILog.Info("Adding vehicle to " + town.GetName());
	local veh = town.Vehicles.Begin();
	local price = AIEngine.GetPrice(AIVehicle.GetEngineType(veh));
	
	if (price > AICompany.GetBankBalance(AICompany.COMPANY_SELF)) {
		AICompany.SetLoanAmount(AICompany.GetMaxLoanAmount());
	}
	local nVeh = AIVehicle.CloneVehicle(town.Depot, veh, true);
	AIVehicle.StartStopVehicle(nVeh);
	
	return true;
}