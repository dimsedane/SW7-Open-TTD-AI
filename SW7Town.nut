class SW7Town extends AITown {
	Stations = null;
	TownId = null;
	ActiveDesires = {};
	Vehicles = null;
	active = null;
	
	constructor(_TownId) {
		::AITown.constructor();
		Stations = AIList();
		TownId = _TownId;
		Vehicles = AIList();
		InitiateDesires();
		active = false;
	}
	
	/**
	 * Add a station to the list of stations of the town.
	 */
	function AddStation(Station) {
		Stations.AddItem(Station,0);
	}
	
	function AddVehicle(Vehicle) {
		Vehicles.AddItem(Vehicle, 0);
	}
	
	/**
	 * Wrapper for retrieving town centre.
	 */
	function GetLocation() {
		return ::AITown.GetLocation(TownId);
	}
	
	/**
	 * Wrapper for retrieving town population.
	 */
	function GetPopulation() {
		return ::AITown.GetPopulation(TownId);
	}
	
	function GetName() {
		return ::AITown.GetName(TownId);
	}
	
	/**
	 * Initiate desires for the town. (IE.: Set all desires to false).
	 */
	function InitiateDesires() {
		ActiveDesires.rawset(Desire.FEED_STATION, Desire(Desire.FEED_STATION));
		ActiveDesires.rawset(Desire.EXTEND_FEEDER_NETWORK, Desire(Desire.EXTEND_FEEDER_NETWORK));
		ActiveDesires.rawset(Desire.ECONOMICALLY_RESPONSIBLE, Desire(Desire.ECONOMICALLY_RESPONSIBLE));
	}
	
	/**
	 * Set a new state for a desire.
	 */
	function setDesire(desire, state) {
		ActiveDesires.rawget(desire.DesireType).active = state;
	}
	
	/**
	 * Get current desire state.
	 * Global desire is checked if and only if Local desire is active. 
	 * (IE. If town does not have desire, it is not necessary to check globally).
	 */
	function getDesireState(desire) {
		if (ActiveDesires.rawin(desire.DesireType) && ActiveDesires.rawget(desire.DesireType).active) {
			if (DesireManager.Desires.rawin(desire.DesireType)) {
				return DesireManager.Desires.rawget(desire.DesireType).active;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
}