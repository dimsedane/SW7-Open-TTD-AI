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
	
	function GenerateFSIntentions();
	
	function GenerateERIntentions();
	
	function GenerateEFNIntentions();
}

function SW7AI::BRF() {
	BeliefsManager.Update();
}

function SW7AI::GenerateDesires() {
	DesireManager.ActivateDesires(BeliefsManager);
}

// Generates intentions from desires.
function SW7AI::Filter() {
	GenerateFSIntentions();
	GenerateERIntentions();
	GenerateEFNIntentions();
	GenerateAVIntentions();
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

function SW7AI::GenerateFSIntentions() {
	local townsToConsider = {};
	local feedDes = DesireManager.Desires.rawget(Desire.FEED_STATION);
	
	if (feedDes.active) {
		foreach (townid, sw7town in BeliefsManager.AllTownsList.towns) {
			if (sw7town.active && sw7town.getDesireState(Desire.FEED_STATION)) {
				townsToConsider.rawset(townid, sw7town);
			}
		}
		
		//Add FeedStationIntention
		foreach (station, _ in BeliefsManager.StationsToFeed) {
			if (townsToConsider.rawin(AIStation.GetNearestTown(station))) {
				local t = townsToConsider.rawget(AIStation.GetNearestTown(station));
				local fsI = FeedStationIntention(station);
				foreach (Intention in Intentions) {
					if (Intention instanceof FeedStationIntention) {
						if (Intention.town.TownId == AIStation.GetNearestTown(station)) {
							fsI = null;
							break;
						}
					}
				}
				
				if (fsI != null) {
					Intentions.append(fsI);
				}
			}
		}
	}
}

function SW7AI::GenerateERIntentions() {
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
}

function SW7AI::GenerateEFNIntentions() {
	local des = DesireManager.Desires.rawget(Desire.EXTEND_FEEDER_NETWORK);
	if (des.active) {
		foreach (town in BeliefsManager.CurrentServicedTownsList) {
			if (town.getDesireState(Desire.EXTEND_FEEDER_NETWORK)) {
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
	}
}

function SW7AI::GenerateAVIntentions() {

}