class TownList {
	towns = {};
	
	/**
	 * Get all towns
	 */
	function loadTowns();
	
	/**
	 * Write the townList, if not already written.
	 * Currently, nothing is done if the List is not empty.
	 * (Note that the list is NOT sorted by population, so it is not a problem.)
	 */
	function UpdateTownList();
}

function TownList::UpdateTownList(){
	if (TownList.towns.len() == 0) {
		TownList.loadTowns();
		return;
	}
}

function TownList::loadTowns() {
	local aitowns = AITownList();
	
	aitowns.Valuate(AITown.GetPopulation);
	aitowns.Sort(AIList.SORT_BY_VALUE, false);
	
	foreach (town, population in aitowns) {
		TownList.towns.rawset(town, SW7Town(town));
	}
}