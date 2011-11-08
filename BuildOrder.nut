class BuildOrder {
	IsExecutable = null;

	constructor () {
		IsExecutable = false;
	}

	/**
	 * Execute the build order.
	 * Returns true on success.
	 */
	function execute ();
	
	/**
	 * Test the build order.
	 * Returns cost on success, null on failure.
	 */
	function test () {
	}
}

class BusStationBuildOrder extends BuildOrder {
	tile = null;
	joinStation = null;
	front = null;
	
	constructor(_location, _joinStation) {
		this.tile = _location;
		this.joinStation = _joinStation;
	}
	
	function execute() {
		if (IsExecutable) {
			if (AIRoad.BuildDriveThroughRoadStation(tile, front, AIRoad.ROADVEHTYPE_BUS, joinStation)) {
				return tile;
			}
		}
		return false;
	}
	
	function test() {
		local test = AITestMode();
		local accounting = AIAccounting();
		
		local built = false;
		built = AIRoad.BuildDriveThroughRoadStation(tile, tile + AIMap.GetTileIndex(1, 0), AIRoad.ROADVEHTYPE_BUS, joinStation);
		if (built) {
			front = tile + AIMap.GetTileIndex(1, 0);
		} else {
			built = AIRoad.BuildDriveThroughRoadStation(tile, tile + AIMap.GetTileIndex(0, 1), AIRoad.ROADVEHTYPE_BUS, joinStation);
			if (built) {
				front = tile + AIMap.GetTileIndex(0, 1);
			}
		}
		
		if (built) { 
			IsExecutable = true;
			return accounting.GetCosts();
		}
		return null;
	}
}

class VehicleBuildOrder extends BuildOrder {
	depot = null;
	engine = null;
	
	constructor (_dpt, _eng) {
		this.depot = _dpt;
		this.engine = _eng;
	}
	
	function test() {
		local test = AITestMode();
		local accounting = AIAccounting();
		
		//Set IsExecutable to true if test succeeds.
		return null;
	}
	
	function execute() {
		if (IsExecutable) {
		
		}
		
		return false;
	}
}

class RoadBuildOrder extends BuildOrder {
	start = null;
	end = null;
	
	constructor (_start, _end) {
		this.start = _start;
		this.end = _end;
	}
	
	function test() {
		local test = AITestMode();
		local accounting = AIAccounting();
		
		//Set IsExecutable to true if test succeeds.
		return null;
	}
	
	function execute() {
		if (IsExecutable) {
		
		}
		return false;
	}
}

class DepotBuildOrder extends BuildOrder {
	location = null;
	front = null;
	
	constructor (_location, _front) {
		this.location = _location;
		this.front = _front;
	}
	
	function test() {
		local test = AITestMode();
		local accounting = AIAccounting();
		local depotbuild = false;
		
		if (AITile.GetMinHeight(front) == AITile.GetMaxHeight(front) && AITile.IsBuildable(front)) {
			depotbuild = AIRoad.BuildRoadDepot(location, front);
		}
		
		if (depotbuild) {
			IsExecutable = true;
			return accounting.GetCosts();
		}
		
		return null;
	}
	
	function execute() {
		if (IsExecutable) {
			AIRoad.BuildRoadDepot(location, front);
			return location;
		}
		
		return false;
	}
}