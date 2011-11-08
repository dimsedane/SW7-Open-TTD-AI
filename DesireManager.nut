class DesireManager {
	Desires = {};
	
	constructor () {
		Desires.rawset(Desire.FEED_STATION, Desire(Desire.FEED_STATION));
		Desires.rawget(Desire.FEED_STATION).active = false;
		Desires.rawset(Desire.ECONOMICALLY_RESPONSIBLE, Desire(Desire.ECONOMICALLY_RESPONSIBLE));
		Desires.rawget(Desire.ECONOMICALLY_RESPONSIBLE).active = false;
	}
}