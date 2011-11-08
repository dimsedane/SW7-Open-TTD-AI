class RepayLoanIntention extends Intention {
	BeliefsManager = null;
	
	constructor(_BeliefsManager) {
		BeliefsManager = _BeliefsManager;
	}
}

function RepayLoanIntention::Execute() {
	if (BeliefsManager.CurrentLoan > 0 && BeliefsManager.CurrentMoney > BeliefsManager.LoanInterval) {
		AICompany.SetMinimumLoanAmount(BeliefsManager.CurrentMoney - BeliefsManager.LoanInterval);
	}
	return true;
}