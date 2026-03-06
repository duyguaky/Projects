
public class Wallet {
	int id;
	int balance;
	int userid;
	
	
	{
		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getBalance() {
		return balance;
	}

	public void setBalance(int balance) {
		this.balance = balance;
	}

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public Wallet(int id, int balance,int userid)
	{
		this.id = id;
		this.balance = balance;
		this.userid = userid;
	}
	
}
