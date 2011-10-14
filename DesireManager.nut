class DesireManager {
	Desires = {};
	
	constructor () {
		Desires.rawset(Desire.FEED_STATION, Desire(Desire.FEED_STATION));
		Desires.rawget(Desire.FEED_STATION).active = false;
		
	}
}