require("SW7Town.nut");
require("TownList.nut");
require("BeliefManager.nut");
require("Intention.nut");
require("DesireManager.nut");
require("Desire.nut");
require("FeedStationIntention.nut");
require("SW7Pathfinder.nut");
require("SW7MEUP.nut");
require("TileListGenerator.nut");
require("BuildOrder.nut");
require("RepayLoanIntention.nut");
require("ExtendNetworkIntention.nut");

class SW7AI extends AIController
{
	/**************************************************************************
    * BDI Data
    **************************************************************************/
	static BeliefsManager = BeliefManager();
	desireManager = null;
	Intentions = array(0);
	
	/**************************************************************************
	* Other variables
	**************************************************************************/
	
	
	/**************************************************************************
	* Function footprint defined below
	**************************************************************************/
	 
	//Create new beliefs based on old beliefs and new data
	function BRF();

	//Generate desires based on current beliefs and intents
	function GenerateDesires();

	//Generates new intents based on current beliefs, intents and desires
	function Filter();

	//Takes an action based on current intents
	function Execute();
	
	constructor()
	{
		PreInitializeState();
	}
	
	function Start()
	{
		InitializeState();
		
		while(true) {
			BRF();
			GenerateDesires();
			Filter();
			Execute();
		}
	}
	
	function ActivateFSDesire();
	
	function ActivateERDesire();
	
	function ActivateEFNDesire();
}

function SW7AI::BRF() {
	BeliefsManager.Update();
}

function SW7AI::GenerateDesires() {
	ActivateFSDesire();
	ActivateERDesire();
	ActivateEFNDesire();
}

// Generates intentions from desires.
function SW7AI::Filter() {
	local townsToConsider = {};
	
	local feedDes = DesireManager.Desires.rawget(Desire.FEED_STATION);
	if (feedDes.active) {
		
		foreach (townid, sw7town in BeliefsManager.AllTownsList) {
			if (sw7town.getDesireState(feedDes)) {
				townsToConsider.rawset(townid, sw7town);
			}
		}
		
		//Add FeedStationIntention
		foreach (station, _ in BeliefsManager.StationsToFeed) {
			if (townsToConsider.rawin(AIStation.GetNearestTown(station))) {
				local fsI = FeedStationIntention(station);
				foreach (Intention in Intentions) {
					if (Intention instanceof FeedStationIntention) {
						if (Intention.Station == station) {
							fsI = null;
						}
					}
				}
				
				if (fsI != null) {
					Intentions.append(fsI);
				}
			}
		}
	}
	
	if (DesireManager.Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active) {
		local alreadyAdded = false;
		foreach (Intention in Intentions) {
			if (Intention instanceof RepayLoanIntention) {
				alreadyAdded = true;
				break;
			}
		}
		
		if (!alreadyAdded) {
			Intentions.append(RepayLoanIntention(BeliefsManager));
		}
	}
	
	local des = DesireManager.Desires.rawget(Desire.EXTEND_FEEDER_NETWORK);
	if (des.active) {
		AILog.Info("Intentions before EFN: " + Intentions.len());
		
		foreach (town in BeliefsManager.CurrentServicedTownsList) {
			if (town.getDesireState(des)) {
				local efnI = ExtendNetworkIntention(town);
				foreach (Intention in Intentions) {
					if (Intention instanceof ExtendNetworkIntention) {
						if (Intention.sw7town == town) {
							efnI = null;
						}
					}
				}
				
				if (efnI != null) {
					Intentions.append(efnI);
				}
			}
		}
		AILog.Info("Intentions after EFN: " + Intentions.len());
	}
}

function SW7AI::Execute() {
	if (Intentions.len() > 0) {
		if (!Intentions[0].Execute()) {
			AILog.Warning("Failed executing current Intention.");
		} else {
			if (Intentions[0] instanceof FeedStationIntention) {
				BeliefsManager.AddServicedTown(Intentions[0].town); //Add the SW7town that matches the serviced town's ID to list of Serviced towns.
			}
		}
		Intentions.remove(0);
	} else {
		AIController.Sleep(10);
	}
}

function SW7AI::PreInitializeState() {
	//Might not be needed to do anything
}

//All initializations here!!!
function SW7AI::InitializeState() {
	desireManager = DesireManager();
}

function SW7AI::ActivateFSDesire() {
	local des = Desire(Desire.FEED_STATION);
	
	if (BeliefsManager.StationsToFeed.Count() == 0) {
		DesireManager.Desires.rawget(des.DesireType).active = false;
	} else {
		DesireManager.Desires.rawget(des.DesireType).active = true;

		foreach (sw7Town, _ in BeliefsManager.AllTownsList) {
			
			town.setDesire(des, (town.GetPopulation() > 400));
		}
	}
	
	if (DesireManager.Desires.rawget(des.DesireType).active) {
		foreach (town in BeliefsManager.ActiveTownList) {
			AILog.Info(town.getDesireState(des) + " XXX " + town.GetName());
			AILog.Info(DesireManager.Desires.rawget(des.DesireType).active);
			AILog.Info(town.ActiveDesires.rawget(des.DesireType).active + " YYY");
		}
	}
}

function SW7AI::ActivateERDesire() {
	if (BeliefsManager.CurrentMoney > BeliefsManager.LoanInterval) {
		DesireManager.Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active = true;
	} else {
		DesireManager.Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active = false;
	}
}

function SW7AI::ActivateEFNDesire() {
	local set = false;
	
	foreach (sTown in BeliefsManager.CurrentServicedTownsList) {
		local popl = sTown.GetPopulation();
		local stMax = 0.00000001 * popl * popl + 0.001 * popl + 2.25;
		local des = Desire(Desire.EXTEND_FEEDER_NETWORK);
		
		if (stMax >= (sTown.Stations.Count() + 1)) {
			sTown.setDesire(des, true);
			set = true;
		} else {
			sTown.setDesire(des, false);
		}
	}
	
	DesireManager.Desires.rawget(Desire.EXTEND_FEEDER_NETWORK).active = set;
}