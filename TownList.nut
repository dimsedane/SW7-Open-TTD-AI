class TownList {
	TownList = AITownList();
	
	function UpdateTownList();
}

function TownList::UpdateTownList(){
	TownList.Valuate(AITown.GetPopulation);
	TownList.Sort(AIList.SORT_BY_VALUE,false);
}