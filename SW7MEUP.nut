class SW7MEUP {
	
}

function SW7MEUP::optimize (options, stations) {
	foreach (option, val in options) {
		local cp = AITile.GetCargoProduction(option, SW7MEUP.getPaxCargoType(), 1, 1, 3);
		val = cp * 100;
		foreach (station in stations) {
			if (AITile.GetDistanceManhattanToTile(station, option) < 4) {
				options.RemoveItem(option);
			} else {
				val -= (AITile.GetDistanceManhattanToTile(station, option))/5;
			}
		}
	}
	options.Sort(AIList.SORT_BY_VALUE, false);
	
	return options;
}

function SW7MEUP::getPaxCargoType () {
	local cargoList = AICargoList();
	cargoList.Valuate(AICargo.HasCargoClass, AICargo.CC_PASSENGERS);
	cargoList.KeepValue(1);
	if (cargoList.Count() == 0) AILog.Error("Your game doesn't have any passengers cargo, and as we are a passenger only AI, we can't do anything");
	return cargoList.Begin();
}