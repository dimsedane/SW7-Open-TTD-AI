class Desire {
	FEED_STATION = 1;
	ECONOMICALLY_RESPONSIBLE = 2;
	EXTEND_FEEDER_NETWORK = 3;
	ADD_VEHICLE = 4;
	
	active = null;
	DesireType = null;
	
	constructor(_desire_type) {
		DesireType = _desire_type;
		active = false;
	}
}