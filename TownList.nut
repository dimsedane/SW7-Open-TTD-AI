class TownList {
	towns = {};
	
	function loadTowns();
	
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