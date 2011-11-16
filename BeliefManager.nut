class BeliefManager {
	/**
	 * Towns in the map, ordered by population.
	 */
	AllTownsList = TownList();
	/**
	 * All towns with a station that is not already fed. (Built from StationsToFeed list)
	 */
	ActiveTownList = {};
	/**
	 * Towns that currently have a feeder station.
	 */
	CurrentServicedTownsList = {};
	PaxCargoId = null;
	
	//Considers train stations only!
	StationsToFeed = null;
	
	CurrentMoney = null;
	CurrentLoan = null;
	CurrentMaxLoan = null;
	LoanInterval = null;
	
	constructor() {
		PaxCargoId = this.getPaxCargoId();
	}
	
	/**
	 * Update the current beliefs of the AI.
	 */
	function Update();
	
	/**
	 * Add a SW7Town to the list of serviced towns.
	 */
	function AddServicedTown(Town);
}

function BeliefManager::Update() {
	AllTownsList.UpdateTownList();
	
	CurrentLoan = AICompany.GetLoanAmount(); //Amount currently loaned
	CurrentMoney = AICompany.GetBankBalance(AICompany.COMPANY_SELF); //Current balance
	CurrentMaxLoan = AICompany.GetMaxLoanAmount(); //Max loan
	LoanInterval = AICompany.GetLoanInterval();
	
	StationsToFeed = AIStationList(AIStation.STATION_TRAIN);
	StationsToFeed.RemoveList(AIStationList(AIStation.STATION_BUS_STOP));
	
	foreach (townid, town in AllTownsList.towns) {
		town.active = false;
		foreach (station, _ in StationsToFeed) {
			if (AIStation.GetNearestTown(station) == townid) {
				town.active = true;
				break;
			}
		}
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