class SW7Town extends AITown {
	Stations = null;
	TownId = null;
	ActiveDesires = null;
	Vehicles = null;
	active = null;
	Depot = null;
	
	constructor(_TownId) {
		::AITown.constructor();
		Stations = AIList();
		TownId = _TownId;
		Vehicles = AIList();
		active = false;
		ActiveDesires = {};
		InitiateDesires();
	}
	
	function setDepot(tile) {
		Depot = tile;
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
		ActiveDesires.rawset(Desire.ADD_VEHICLE, Desire(Desire.ADD_VEHICLE));
	}
	
	/**
	 * Set a new state for a desire.
	 */
	function setDesire(desire, state) {
		ActiveDesires.rawget(desire).active = state;
	}
	
	/**
	 * Get current desire state.
	 * Global desire is checked if and only if Local desire is active. 
	 * (IE. If town does not have desire, it is not necessary to check globally).
	 */
	function getDesireState(desire) {
		if (ActiveDesires.rawin(desire)) {
			if (ActiveDesires.rawget(desire).active) {
				if (DesireManager.Desires.rawget(desire).active) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
}