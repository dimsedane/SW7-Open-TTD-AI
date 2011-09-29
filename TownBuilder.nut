class TownBuilder {
	Town = null;
	
	constructor(TownId) {
		Town = SW7Town(TownId);
	}
	
	function Build() {
		local loc = Town.GetLocation();
		AISign.BuildSign(loc,"PENIS");
		BeliefManager.AddServicedTown(Town);
	}
}