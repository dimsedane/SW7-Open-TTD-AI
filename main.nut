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
require("AddVehicleIntention.nut");
require("SW7IntentionList.nut");

class SW7AI extends AIController
{
	/**************************************************************************
    * BDI Data
    **************************************************************************/
	static BeliefsManager = BeliefManager();
	desireManager = null;
	Intentions = SW7IntentionList();
	
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
	
	Intentions.OutruleExpensive();
	
	Intentions.Sort();
}

function SW7AI::Execute() {
	if (Intentions.Count() > 0) {
		local intn = Intentions.pop();
		
		if (intn != null) {
			if (!intn.Execute()) {
			
				if (intn instanceof FeedStationIntention) {
					AILog.Warning("Failed executing current FSIntention.");
				} else if (intn instanceof ExtendNetworkIntention) {
					AILog.Warning("Failed executing current ENIntention.");
				} else if (intn instanceof RepayLoanIntention) {
					AILog.Warning("Failed executing current PLIntention.");
				} else if (intn instanceof AddVehicleIntention) {
					AILog.Warning("Failed executing current AVIntention.");
				}
			} else {
				if (intn instanceof FeedStationIntention) {
					BeliefsManager.AddServicedTown(intn.town); //Add the SW7town that matches the serviced town's ID to list of Serviced towns.
				}
			}
		} else {
			AIController.Sleep(30);
		}
	} else {
		AIController.Sleep(30);
	}
}

function SW7AI::PreInitializeState() {
	//Might not be needed to do anything
}

//All initializations here!!!
function SW7AI::InitializeState() {
	desireManager = DesireManager();
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
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
				local fsI = FeedStationIntention(station);
				
				local exFsI = Intentions.Get(fsI);
				if (exFsI == null) {
					if (fsI.Test()) {
						Intentions.insert(fsI, fsI.GetPrio());
					}
				} else {
					if (exFsI.Test()) {
						Intentions.Update(exFsI, exFsI.GetPrio());
					} else {
						Intentions.remove(exFsI);
					}
				}
			}
		}
	}
}

function SW7AI::GenerateERIntentions() {
	if (DesireManager.Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active) {
		local erI = RepayLoanIntention(BeliefsManager);
		
		local exErI = Intentions.Get(erI);
		if (exErI == null) {
			if (erI.Test()) {
				Intentions.insert(erI, erI.GetPrio());
			}
		} else {
			if (exErI.Test()) {
				Intentions.Update(exErI, exErI.GetPrio());
			} else {
				Intentions.remove(exErI);
			}
		}
	}
}

function SW7AI::GenerateEFNIntentions() {
	local des = DesireManager.Desires.rawget(Desire.EXTEND_FEEDER_NETWORK);
	if (des.active) {
		foreach (town in BeliefsManager.CurrentServicedTownsList) {
			if (town.getDesireState(Desire.EXTEND_FEEDER_NETWORK)) {
				local efnI = ExtendNetworkIntention(town);
				
				local exEfnI = Intentions.Get(efnI);
				if (exEfnI == null) {
					if (efnI.Test()) {
						Intentions.insert(efnI, efnI.GetPrio());
					}
				} else {
					if (exEfnI.Test()) {
						Intentions.Update(exEfnI, exEfnI.GetPrio());
					} else {
						Intentions.remove(exEfnI);
					}
				}
			}
		}
	}
}

function SW7AI::GenerateAVIntentions() {
	local des = Desire.ADD_VEHICLE;
	
	if (DesireManager.Desires.rawget(des).active) {
		foreach (town in BeliefsManager.CurrentServicedTownsList) {
			if (town.getDesireState(des)) {
				local avI = AddVehicleIntention(town);
				
				local exAvI = Intentions.Get(avI);
				if (exAvI == null) {
					if (avI.Test()) {
						Intentions.insert(avI, avI.GetPrio());
					}
				} else {
					if (exAvI.Test()) {
						Intentions.Update(exAvI, exAvI.GetPrio());
					} else {
						Intentions.remove(exAvI);
					}
				}
			}
		}
	}
}