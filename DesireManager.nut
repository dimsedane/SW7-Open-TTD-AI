class DesireManager {
	Desires = {};
	
	constructor () {
		Desires.rawset(Desire.FEED_STATION, Desire(Desire.FEED_STATION));
		Desires.rawget(Desire.FEED_STATION).active = false;
		Desires.rawset(Desire.ECONOMICALLY_RESPONSIBLE, Desire(Desire.ECONOMICALLY_RESPONSIBLE));
		Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active = false;
		Desires.rawset(Desire.EXTEND_FEEDER_NETWORK, Desire(Desire.EXTEND_FEEDER_NETWORK));
		Desires.rawget(Desire.EXTEND_FEEDER_NETWORK).active = false;
	}
	
	
	function ActivateDesires(bm);
	
	/**
	 * Activate FeedStation Desire for stations it makes sense in.
	 * @param BeliefManager bm Instance of a BeliefManager
	 */
	function ActivateFSDesire(bm);
	
	function ActivateERDesire(bm);
	
	function ActivateEFNDesire(bm);
}

function DesireManager::ActivateDesires(bm) {
	DesireManager.ActivateFSDesire(bm);
	DesireManager.ActivateERDesire(bm);
	DesireManager.ActivateEFNDesire(bm);
}

function DesireManager::ActivateFSDesire(bm) {
	local des = (Desire.FEED_STATION);
	
	if (bm.StationsToFeed.Count() == 0) {
		DesireManager.Desires.rawget(des).active = false;
	} else {
		DesireManager.Desires.rawget(des).active = true;

		foreach (id, town in bm.AllTownsList.towns) {
			if (town.active) {
				town.setDesire(des, (town.GetPopulation() > 400));
			}
		}
	}
}

function DesireManager::ActivateERDesire(bm) {
	local des = Desire.ECONOMICALLY_RESPONSIBLE;
	if (bm.CurrentMoney > bm.LoanInterval) {
		DesireManager.Desires.rawget(des).active = true;
	} else {
		DesireManager.Desires.rawget(des).active = false;
	}
}

function DesireManager::ActivateEFNDesire(bm) {
	local townsToExtend = false;
	local des = Desire.EXTEND_FEEDER_NETWORK;
	
	foreach (sTown in bm.CurrentServicedTownsList) {
		local popl = sTown.GetPopulation();
		local stMax = 0.00000001 * popl * popl + 0.001 * popl + 2.25;
		
		if (stMax >= (sTown.Stations.Count() + 1)) {
			sTown.setDesire(des, true);
			townsToExtend = true;
		} else {
			sTown.setDesire(des, false);
		}
	}
	
	DesireManager.Desires.rawget(des).active = townsToExtend;
}