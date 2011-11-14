class SW7Town extends AITown {
	Stations = null;
	TownId = null;
	ActiveDesires = {};
	
	constructor(_TownId) {
		::AITown.constructor();
		Stations = AIList();
		TownId = _TownId;
	}
	
	/**
	 * Add a station to the list of stations of the town.
	 */
	function AddStation(Station) {
		Stations.AddItem(Station,0);
	}
	
	/**
	 * Wrapper for retrieving town centre.
	 */
	function GetLocation() {
		return ::AITown.GetLocation(TownId);
	}
	
	/**
	 * Initiate desires for the town. (IE.: Set all desires to false).
	 */
	function InitiateDesires() {
		ActiveDesires.rawset(Desire.FEED_STATION, false);
	}
	
	/**
	 * Set a new state for a desire.
	 */
	function setDesire(desire, state) {
		if (state) {
			ActiveDesires.rawset(desire, true);
		} else {
			ActiveDesires.rawset(desire, false);
		}
	}
	
	/**
	 * Get current desire state. If town has the desire active, it is also checked, whether the desire itself is active.
	 */
	function getDesireState(desire) {
		if (ActiveDesires.rawin(desire.DesireType) && ActiveDesires.rawget(desire.DesireType)) {
			if (DesireManager.Desires.rawin(desire.DesireType)) {
				return DesireManager.Desires.rawget(desire.DesireType);
			}
		}
	}
}