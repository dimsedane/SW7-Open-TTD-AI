class SW7AI extends AIController
{
   /**************************************************************************
    * BDI Data
    *************************************************************************/
	Beliefs = array(0);
	Intents = array(0);
	Desires = array(0);
	
	/**************************************************************************
	 * Other variables
	 *************************************************************************/
	CurrentTownList = null;
	
	
	/**************************************************************************
	 * Function footprint defined below
	 *************************************************************************/
	 
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
	
}

function SW7AI::GenerateDesires() {

}

function SW7AI::Filter() {
	
}

function SW7AI::Execute() {
	
}

function SW7AI::PreInitializeState() {
	CurrentTownList = TownList();
}

function SW7AI::InitializeState() {
	
}