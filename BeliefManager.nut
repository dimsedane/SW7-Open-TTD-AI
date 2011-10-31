class BeliefManager {
	CurrentTownList = TownList();
	ActiveTownList = {};
	CurrentServicedTownsList = {};
	
	//Considers train stations only!
	StationsToFeed = null;
	
	CurrentMoney = 0;
	CurrentLoan = 0;
	CurrentMaxLoan = 0;
	
	function Update();
	
	constructor() {
	}
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

function BeliefManager::AddServicedTown(Town) {
	BeliefManager.CurrentServicedTownsList.rawset(Town.TownId,Town);
}