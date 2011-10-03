class TownList extends AITownList {
	
	function UpdateTownList();
}

function TownList::UpdateTownList(){
	this.Valuate(AITown.GetPopulation);
	this.Sort(AIList.SORT_BY_VALUE,false);
}