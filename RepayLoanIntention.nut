class RepayLoanIntention extends Intention {
	BeliefsManager = null;
	
	constructor(_BeliefsManager) {
		::Intention.constructor();
		this.prio = 81; //
		BeliefsManager = _BeliefsManager;
	}
}

function RepayLoanIntention::Execute() {
	if (BeliefsManager.CurrentLoan > 0 && BeliefsManager.CurrentMoney > BeliefsManager.LoanInterval) {
		AICompany.SetLoanAmount(BeliefsManager.CurrentLoan - BeliefsManager.LoanInterval);
	}
	return true;
}