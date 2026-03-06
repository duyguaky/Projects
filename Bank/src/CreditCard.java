public class CreditCard extends Card {
	public int getDebtBalance() {
		return debtBalance;
	}


	public void setDebtBalance(int debtBalance) {
		this.debtBalance = debtBalance;
	}


	int debtBalance;
	
	public CreditCard(int id, String cardNo,int debtBalance) {
		super(id,cardNo);
		this.debtBalance = debtBalance;
	}
	
	
	public void showcreditcardInfo()
    {
    	System.out.println("id: " + id);
    	System.out.println("Kart no:" + cardNo);
    	System.out.println("Borç Bilgisi:" + debtBalance);
    	
    }
}

