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
}

function SW7AI::BRF() {
	BeliefsManager.Update();
}

function SW7AI::GenerateDesires() {
	if (BeliefsManager.StationsToFeed.Count() > 0) {
		DesireManager.Desires.rawget(Desire.FEED_STATION).active = true;
		
		foreach (town in BeliefManager.ActiveTownList) {
			if (AITown.GetPopulation(town.TownId) > 400) {
				town.setDesire(Desire.FEED_STATION, true);
			}
		}
	} else {
		DesireManager.Desires.rawget(Desire.FEED_STATION).active = false;
	}
	
	if (BeliefsManager.CurrentMoney > BeliefsManager.LoanInterval) {
		DesireManager.Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active = true;
	} else {
		DesireManager.Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active = false;
	}
	
	if (BeliefsManager.CurrentServicedTownsList.len() > 0) {
		local ExtendTown = false;
		foreach (town in BeliefsManager.CurrentServicedTownsList) {
			local popl = town.GetPopulation();
			local stCount = 0.00000001 * popl * popl + 0.001 * popl + 2.25;
			
			if (stCount > town.Stations.Count() + 1) {
				town.setDesire(Desire.EXTEND_FEEDER_NETWORK, true);
				ExtendTown = true;
			} else {
				town.setDesire(Desire.EXTEND_FEEDER_NETWORK, false);
			}
		}
		if (ExtendTown) {
			desireManager.Desires.rawget(Desire.EXTEND_FEEDER_NETWORK).active = true;
		} else {
			desireManager.Desires.rawget(Desire.EXTEND_FEEDER_NETWORK).active = false;
		}
	}
}

// Generates intentions from desires.
function SW7AI::Filter() {
	local activeDesires = {};
	local townsToConsider = {};
	
	foreach (desire in DesireManager.Desires) {
		if (desire.active) {
			activeDesires.rawset(desire.DesireType, desire);
		}
	}
	
	if (activeDesires.rawin(Desire.FEED_STATION)) {
		foreach (townid, sw7town in BeliefsManager.ActiveTownList) {
			foreach (desire in activeDesires) {
				if (sw7town.getDesireState(desire)) {
					townsToConsider.rawset(townid, sw7town);
				}
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
	
	if (activeDesires.rawin(Desire.ECONOMICALLY_RESPONSIBLE)) {
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
	
	if (activeDesires.rawin(Desire.EXTEND_FEEDER_NETWORK)) {
		AILog.Info("EXTEND");
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
		AIController.Sleep(100);
	}
}

function SW7AI::PreInitializeState() {
	//Might not be needed to do anything
}

//All initializations here!!!
function SW7AI::InitializeState() {
	desireManager = DesireManager();
}