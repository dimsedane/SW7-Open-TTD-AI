class Intention {
	BUILD_STATION_LARGEST_TOWN = 1;
	SOMETHING_ELSE = 2;
	
	ThisIntention = null;

	constructor(IntentionType) {
		ThisIntention = IntentionType;
	}
	
	
	function GetIntention() {
		return ThisIntention;
	}
	
	function CheckRequirementsMet() {
		switch(ThisIntention) {
			case BUILD_STATION_LARGEST_TOWN:
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