class SW7IntentionList
{
	intns = null;
	prios = null;

	constructor()
	{
		intns = [];
	}
	
	/**
	 * Insert an item with priority to the IntentionList
	 * @param Intention item The Intention to insert.
	 * @param int prio The priority of the Intention.
	 */
	function insert(item, prio);
	
	/**
	 * Get the top Intention (if highest priority should be returned, sort first!).
	 * @return Intention
	 */
	function pop();
	
	/**
	 * Get the amount of Intentions in the List.
	 * @return int
	 */
	function Count() {
		return this.intns.len();
	}
	
	/**
	 * Sort the List, s.t. the higest prioritized Intention can be popped off the List.
	 */
	function Sort();
	
	/**
	 * Check if an Intention is already in the List.
	 * @param Intention intention The Intention to find.
	 * @return bool Whether the intention exists.
	 */
	function Exists(intention);
	
	/**
	 * Get the Intention that matches the provided intention, if it exists in the list.
	 * @param Intention intention The intention to search for
	 * @return Intention The matching intention. Null if not found.
	 */
	function Get(intention);
	
	/**
	 * Get the Index of an intention.
	 * @param Intention intention The Intention to search for.
	 * @return int the index of the Intention.
	 */
	function GetIndex(intention);
}

function SW7IntentionList::Exists(intention) {
	foreach (intn in intns) {
		if (intn[0].Equals(intention)) return true;
	}
	return false;
}

function SW7IntentionList::Get(intention) {
	foreach (intn in intns) {
		if (intention.Equals(intn[0])) return intn[0];
	}
	return null;
}

function SW7IntentionList::GetIndex(intention) {
	foreach (idx, intn in intns) {
		if (intention.Equals(intn[0])) return idx;
	}
	
	return null;
}

function SW7IntentionList::Update(intention, nval) {
	local key = GetIndex(intention);
	
	if (key == null) return false;
	intns[key][1] = nval;
	return true;
}

function SW7IntentionList::insert(intn, prio) {
	intns.append([intn, prio]);
}

function SW7IntentionList::pop() {
	local out = intns.pop();
	local ret;
	
	if (out[1] < 0) {
		ret = null;
	} else {
		ret = out[0];
	}
	return ret;
}

function SW7IntentionList::remove(intention) {
	local pos = GetIndex(intention);
	if (pos != null) {
		intns.remove(pos);
	}
}

function SW7IntentionList::Sort() {
	intns.sort(SW7IntentionList.cmp);
}

function SW7IntentionList::cmp(a, b) {
	if (a[1] > b[1]) return 1;
	if (a[1] < b[1]) return -1;
	return 0;
}

function SW7IntentionList::OutruleExpensive() {
	foreach (intn in intns) {
		if (intn[0].GetCost() > AICompany.GetBankBalance(AICompany.COMPANY_SELF) + (AICompany.GetMaxLoanAmount() - AICompany.GetLoanAmount())) {
			intn[1] = -1;
		}
	}
}