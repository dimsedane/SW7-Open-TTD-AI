class SW7AI extends AIController
{
	CurrentTownList = null;
	
	function BRF();
	function GenerateOptions();
	function Filter();
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
			GenerateOptions();
			Filter();
			Execute();
		}
	}
}

function SW7AI::BRF() {
	
}

function SW7AI::GenerateOptions() {

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