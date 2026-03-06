public class BankCard extends Card {
	public int getBalance() {
		return balance;
	}

	public void setBalance(int balance) {
		this.balance = balance;
	}

	int balance;
	
	public BankCard(int id, String cardNo,int balance) {
		super(id,cardNo);
		this.balance = balance;
	}
}

