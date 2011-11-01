class SW7MEUP {
	/**
	 * Takes a list of tiles for station placement, as well as a list of station tiles.
	 * Orders the list of options by the cargo production within 3 tiles, as well as the distance to the provided station tiles.
	 * Tiles too close to existing tiles (currently 3), are removed.
	 */
	function optimize(options, stationtiles);
	
	/**
	 * Retrieve the CargoId for the PAX cargo class.
	 */
	function getPaxCargoId ();
}

function SW7MEUP::optimize (options, stationtiles) {
	foreach (option, val in options) {
	local cp = AITile.GetCargoProduction(option, SW7AI.BeliefsManager.PaxCargoId, 1, 1, 3);
		local tmpCost = 6 * cp;
		foreach (station in stationtiles) {
			if (AITile.GetDistanceManhattanToTile(station, option) < 4) {
				options.RemoveItem(option);
			} else {
				tmpCost += (1/(option, AITile.GetDistanceManhattanToTile(station, option)));
			}
		}
		options.SetValue(option, tmpCost);
	}
	
	options.Sort(AIList.SORT_BY_VALUE, false);
	
	return options;
}