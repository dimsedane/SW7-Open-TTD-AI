class BeliefManager {
	CurrentTownList = TownList();
	ActiveTownList = {};
	CurrentServicedTownsList = {};
	PaxCargoId = null;
	
	//Considers train stations only!
	StationsToFeed = null;
	
	CurrentMoney = 0;
	CurrentLoan = 0;
	CurrentMaxLoan = 0;
	
	constructor() {
		PaxCargoId = this.getPaxCargoId();
	}
	
	/**
	 * Update the current beleifs of the AI.
	 */
	function Update();
	
	/**
	 * Add a SW7Town to the list of serviced towns.
	 */
	function AddServicedTown(Town);
}

function BeliefManager::Update() {
	CurrentTownList.UpdateTownList();
	
	CurrentLoan = AICompany.GetLoanAmount();
	CurrentMoney = AICompany.GetBankBalance(AICompany.COMPANY_SELF);
	CurrentMaxLoan = AICompany.GetMaxLoanAmount();
	
	StationsToFeed = AIStationList(AIStation.STATION_TRAIN);
	
	StationsToFeed.RemoveList(AIStationList(AIStation.STATION_BUS_STOP));
	
	foreach (station, _ in StationsToFeed) {
		local townid = AIStation.GetNearestTown(station);
		ActiveTownList.rawset(townid, SW7Town(townid));
	}
}

function BeliefManager::AddServicedTown(_SW7Town) {
	BeliefManager.CurrentServicedTownsList.rawset(_SW7Town.TownId, _SW7Town);
}

function BeliefManager::getPaxCargoId () {
	local cargoList = AICargoList();
	cargoList.Valuate(AICargo.HasCargoClass, AICargo.CC_PASSENGERS);
	cargoList.KeepValue(1);
	if (cargoList.Count() == 0) AILog.Error("Your game doesn't have any passengers cargo, and as we are a passenger only AI, we can't do anything");
	return cargoList.Begin();
}