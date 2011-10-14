/**
	All intentions should extend this class. Thus, when executing an intention, calling Intention.Execute is sufficient.
*/
class Intention {
	function Execute();
	
	constructor() {
	
	}
}

function Intention::Execute() {
	return true;
}