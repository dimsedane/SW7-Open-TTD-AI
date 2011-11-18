/**
	All intentions should extend this class. Thus, when executing an intention, calling Intention.Execute is sufficient.
*/
class Intention {
	prio = null; //Priority of the intention - defaults to 5.
	function Execute();
	
	/**
	 * Devise Intention priority based on population.
	 
	 */
	function capPop(population);
	
	constructor() {
		prio = 5;
	}
}

function Intention::Execute() {
	return true;
}

function Intention::capPop(population) {
	if (population < 1000) {
		this.prio = 0.009 * population + 0.035;
	} else if (population <= 4000) {
		this.prio = 0.027 * pop - 16.7; //1000 = 9,3; 3999 = 87,274
	} else {
		this.prio = 90;
	}
}