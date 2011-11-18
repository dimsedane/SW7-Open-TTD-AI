/**
	All intentions should extend this class. Thus, when executing an intention, calling Intention.Execute is sufficient.
*/
class Intention {
	function Execute();
	
	function GetPrio();
	
	function GetCost();
	
	constructor() {
	}
}

function Intention::Execute() {
	return true;
}

function Intention::GetPrio() {
	return 5;
}

function Intention::Equals(intention) {
	return false;
}

function Intention::GetCost() {
	return 0;
}