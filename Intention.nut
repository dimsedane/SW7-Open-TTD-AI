/**
	All intentions should extend this class. Thus, when executing an intention, calling Intention.Execute is sufficient.
*/
class Intention {
	/**
	 * Tests whether the Intention is executable.
	 * @return bool Whether the Intention is executable
	 */ 
	function Test();
	
	/**
	 * Executes the Intention
	 * @return bool Whether the execution was successful
	 */
	function Execute();
	
	/**
	 * Any actions to be executed after the Intention is successfully executed (ie. Execute returns true).
	 * @return bool success.
	 */
	function PostExecute();
	
	/**
	 * Gets the Intention Priority
	 * @return int The priority of the Intention (between -1 and 100)
	 */
	function GetPrio();
	
	/**
	 * Gets the cost of the Intention
	 * @return int the Intention Cost (> 0)
	 */
	function GetCost();
	
	constructor() {
	}
}
function Intention::Test() {
	return false;
}

function Intention::Execute() {
	return false;
}

function Intention::PostExecute() {
	return false;
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