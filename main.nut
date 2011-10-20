require("SW7Town.nut");
require("TownList.nut");
require("BeliefManager.nut");
require("TownBuilder.nut");
require("Intention.nut");
require("DesireManager.nut");
require("Desire.nut");
require("FeedStationIntention.nut");
require("SW7Pathfinder.nut");

class SW7AI extends AIController
{
	/**************************************************************************
    * BDI Data
    **************************************************************************/
	BeliefsManager = BeliefManager();
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

//Instantly activates FEED_STATION desire. 
//This is supposed to be done only if beliefs match.
function SW7AI::GenerateDesires() {
	DesireManager.Desires.rawget(Desire.FEED_STATION).active = true;
	foreach (town in BeliefManager.ActiveTownList) {
		town.setDesire(Desire.FEED_STATION, true);
	}
}

//NOTDONE!
//Currently does not create list of intentions.
//Should consider other things than towns.
function SW7AI::Filter() {
	local activeDesires = {};
	local townsToConsider = {};
	
	foreach (desire in DesireManager.Desires) {
		if (desire.active) {
			activeDesires.rawset(desire.DesireType, desire);
		}
	}
	
	foreach (town in BeliefsManager.ActiveTownList) {
		foreach (desire in activeDesires) {
			if (town.getDesireState(desire)) {
				townsToConsider.rawset(town.TownId, town);
				
			}
		}
	}
	
	foreach (stationid, station in BeliefsManager.StationsToFeed) {
		Intentions.append(FeedStationIntention(stationid));
	}
}

function SW7AI::Execute() {
	if (Intentions.len() > 0)
		Intentions[0].Execute();
}

function SW7AI::PreInitializeState() {
	//Might not be needed to do anything
}

//All initializations here!!!
function SW7AI::InitializeState() {
	desireManager = DesireManager();
}