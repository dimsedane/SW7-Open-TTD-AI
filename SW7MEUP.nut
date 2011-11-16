class SW7MEUP {
	RV_PARAM_FAST = 0;
	RV_PARAM_HIGH_CARGO_CAPACITY = 1;
	RV_PARAM_CHEAP = 2;
	
	/**
	 * Takes a list of tiles for station placement, as well as a list of station tiles.
	 * Orders the list of options by the cargo production within 3 tiles, as well as the distance to the provided station tiles.
	 */
	function optimize(options, stationtiles);
	
	/**
	 * Retrieve available road vehicles, based on the provided flag (RV_PARAM_FAST, RV_PARAM_HIGH_CARGO_CAPACITY or RV_PARAM_CHEAP).
	 */
	function GetRoadVehicle(flag);
}

function SW7MEUP::optimize (options, stationtiles) {
	foreach (option, val in options) {
		local cp = AITile.GetCargoProduction(option, SW7AI.BeliefsManager.PaxCargoId, 1, 1, 3);
		local tmpCost = cp;
		foreach (station in stationtiles) {
			local tmp = AITile.GetDistanceManhattanToTile(station, option);
			switch (tmp) {
				case 0:
					options.RemoveItem(option);
					break;
				case 1:
					tmpCost -= 3200;
					break;
				case 2:
					tmpCost -= 1600;
					break;
				case 3:
					tmpCost -= 800;
					break;
				case 4:
					tmpCost -= 400;
					break;
				case 5:
					tmpCost -= 200;
					break;
				case 6:
					tmpCost -= 100;
					break;
				default:
					tmpCost += 3/tmp;
					break;
			}
		}
		options.SetValue(option, tmpCost);
	}
	
	options.Sort(AIList.SORT_BY_VALUE, false);
	
	return options;
}

function SW7MEUP::GetRoadVehicle (flag) {
	local eng;
	local engList = AIEngineList(AIVehicle.VT_ROAD);
	local sortOrder = null;
	
	if (engList.IsEmpty()) return null;
	
	switch (flag) {
		case (SW7MEUP.RV_PARAM_FAST):
			engList.Valuate(AIEngine.GetMaxSpeed);
			sortOrder = AIList.SORT_DESCENDING;
			break;
		case (SW7MEUP.RV_PARAM_HIGH_CARGO_CAPACITY):
			engList.Valuate(AIEngine.GetCapacity);
			sortOrder = AIList.SORT_DESCENDING;
			break;
		case (SW7MEUP.RV_PARAM_CHEAP):
			engList.Valuate(AIEngine.GetPrice);
			sortOrder = AIList.SORT_ASCENDING;
			break;
		default:
			engList.Valuate(AIEngine.GetPrice);
			sortOrder = AIList.SORT_ASCENDING;
			break;
	}
	engList.Sort(AIList.SORT_BY_VALUE, sortOrder);
	
	return engList;
}