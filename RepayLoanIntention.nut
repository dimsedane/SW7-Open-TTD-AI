class RepayLoanIntention extends Intention {
	BeliefsManager = null;
	
	constructor(_BeliefsManager) {
		::Intention.constructor();
		BeliefsManager = _BeliefsManager;
	}
}

function RepayLoanIntention::Test() {
	return BeliefsManager.CurrentLoan > 0 && BeliefsManager.CurrentMoney > BeliefsManager.LoanInterval;
}

function RepayLoanIntention::Execute() {
	AICompany.SetMinimumLoanAmount(BeliefsManager.CurrentLoan - BeliefsManager.CurrentMoney);
	return true;
}

function RepayLoanIntention::Equals(intention) {
	if (intention instanceof RepayLoanIntention) return true;
	return false;
}

function RepayLoanIntention::GetPrio() {
	return 85;
}