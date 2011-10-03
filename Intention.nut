class Intention {
	ThisIntention = null;

	/**************************************************************************
	* Constants that should have been enums if this lang made sense.
	**************************************************************************/
	BUILD_INITIAL_STATION_IN_TOWN = 0;
	BUILD_ADITIONAL_STATION = 1;
	SOMETHING_ELSE = 3;
	
	
	constructor(IntentionType) {
		ThisIntention = IntentionType;
	}
	
	function GetIntention() {
		return ThisIntention;
	}
	
	function CheckRequirementsMet() {
		switch(ThisIntention) {
			case BUILD_INITIAL_STATION_IN_TOWN:
				return CheckBuildStationLargestTown();
				break;
			default:
				throw "The current intention is not known be the requirement checker.";
		}
	}
	
	function CheckBuildStationLargestTown() {
		local LargestTown = BeliefManager.CurrentTownList.Begin();
		
		if(BeliefManager.CurrentServicedTownsList.rawin(LargestTown)) {
			return false;
		}	
		//TODO: Update to take other things into account
		
		return true;
	}
}