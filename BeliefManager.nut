class BeliefManager {
	CurrentTownList = TownList();
	CurrentMoney = 0;
	CurrentLoan = 0;
	CurrentMaxLoan = 0;
	
	function Update();
	
	constructor() {
		
	}
}

function BeliefManager::Update() {
	CurrentTownList.UpdateTownList();
	
	CurrentLoan = AICompany.GetLoanAmount();
	CurrentMoney = AICompany.GetBankBalance();
	CurrentMaxLoan = AICompany.GetMaxLoanAmount();	
}