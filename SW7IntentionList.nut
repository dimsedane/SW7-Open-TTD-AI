class SW7IntentionList
{
	intns = null;
	prios = null;

	constructor()
	{
		intns = [];
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
		if (intention.Equals(intn[0])) return true;
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