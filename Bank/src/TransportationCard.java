public class TransportationCard extends Card {
	public int getBalance() {
		return balance;
	}
	public void setBalance(int balance) {
		this.balance = balance;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	int balance;
	String city;
	public TransportationCard(int id, String cardNo,int balance, String city) {
		super(id,cardNo);
		this.balance = balance;
		this.city = city;
	}
}

