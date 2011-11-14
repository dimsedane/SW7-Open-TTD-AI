class RepayLoanIntention extends Intention {
	BeliefsManager = null;
	
	constructor(_BeliefsManager) {
		BeliefsManager = _BeliefsManager;
	}
}

function RepayLoanIntention::Execute() {
	if (BeliefsManager.CurrentLoan > 0 && BeliefsManager.CurrentMoney > BeliefsManager.LoanInterval) {
		AICompany.SetLoanAmount(BeliefsManager.CurrentLoan - BeliefsManager.LoanInterval);
	}
	return true;
}