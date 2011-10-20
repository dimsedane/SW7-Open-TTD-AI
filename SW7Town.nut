class SW7Town extends AITown {
	Stations = null;
	TownId = null;
	ActiveDesires = {};
	
	constructor(_TownId) {
		::AITown.constructor();
		Stations = AIList();
		TownId = _TownId;
	}
	
	function AddStation(Station) {
		Station.AddItem(Station,0);
	}
	
	function GetLocation() {
		return ::AITown.GetLocation(TownId);
	}
	
	function InitiateDesires() {
		ActiveDesires.rawset(Desire.FEED_STATION, false);
	}
	
	function setDesire(desire, state) {
		if (state) {
			ActiveDesires.rawset(desire, DesireManager.Desires.rawget(desire));
		} else {
			ActiveDesires.rawset(desire, false);
		}
	}
	
	function getDesireState(desire) {
		if (!ActiveDesires.rawget(desire.DesireType)) {
			return false;
		}
		return true;
	}
}