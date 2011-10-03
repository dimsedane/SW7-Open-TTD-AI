require("SW7Town.nut");
require("TownList.nut");
require("BeliefManager.nut");
require("TownBuilder.nut");
require("Intention.nut");

class SW7AI extends AIController
{
	/**************************************************************************
    * BDI Data
    **************************************************************************/
	BeliefsManager = BeliefManager();
	Intentions = array(0);
	Desires = array(0);
	
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
	Desires.clear();
	
	local size = Intentions.len();
	
	foreach(i, intention in Intentions) {
		if(intention.CheckRequirementsMet()) {
			Desires.append(intention);
		}
	}
}

function SW7AI::Filter() {
	Intentions.clear();
	Intentions.extend(Desires);
	
}

function SW7AI::Execute() {
	if(Intentions.len() < 1) {
		AILog.Info("No intentions to execute");
		return;
	}
	local ExecuteIntention = Intentions[0];
	
	switch(ExecuteIntention.GetIntention()) {
		case Intention.BUILD_INITIAL_STATION_IN_TOWN:
			local TB = TownBuilder(BeliefManager.CurrentTownList.Begin());
			TB.Build();
			break;
		default:
			AILog.Error("An intention was selected for execution, but was not recogniced by the excution handler");
			break;
	}
}

function SW7AI::PreInitializeState() {
	
}

function SW7AI::InitializeState() {
	Intentions.append(Intention(Intention.BUILD_INITIAL_STATION_IN_TOWN));
}