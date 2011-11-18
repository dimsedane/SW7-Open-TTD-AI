class SW7IntentionList
{
	intns = null;
	prios = null;

	constructor()
	{
		intns = [];
		prios = [];
	}
	
	function insert(item, prio);
	
	function pop();
	
	function Count() {
		return this.intns.len();
	}
	
	function Sort();
	
	function Exists(intention);
}

function SW7IntentionList::Exists(intention) {
	foreach (intn in intns) {
		if (intention.Equals(intn)) return true;
	}
	return false;
}

function SW7IntentionList::Get(intention) {
	foreach (intn in intns) {
		if (intention.Equals(intn)) return intn;
	}
	return null;
}

function SW7IntentionList::GetIndex(intention) {
	foreach (idx, intn in intns) {
		if (intention.Equals(intn)) return idx;
	}
	
	return null;
}

function SW7IntentionList::Update(intention, nval) {
	local key = GetIndex(intention);
	
	if (key == null) return false;
	prios[key] = nval;
	return true;
}

function SW7IntentionList::insert(intn, prio) {
	intns.append(intn);
	prios.append(prio);
}

function SW7IntentionList::pop() {
	prios.pop();
	return intns.pop();
}

function SW7IntentionList::remove(intention) {
	local pos = GetIndex(intention);
	if (pos != null) {
		intns.remove(pos);
		prios.remove(pos);
	}
}

function SW7IntentionList::Sort() {
	prios.sort();
}

function SW7IntentionList::OutruleExpensive() {
	foreach (idx, prio in prios) {
		if (intns[idx].GetCost() > AICompany.GetBankBalance(AICompany.COMPANY_SELF) + (AICompany.GetMaxLoanAmount() - AICompany.GetLoanAmount())) {
			prios[idx] = -1;
		}
	}
}