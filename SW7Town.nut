class SW7Town extends AITown {
	Stations = null;
	TownId = null;
	
	constructor(_TownId) {
		::AITown.constructor();
		Stations = AIList();
		TownId = _TownId;
	}
	
	function AddStation(Station) {
		Station.AddItem(Station,0);
	}
}

function SW7Town::IsServiced(Town) {
	
}