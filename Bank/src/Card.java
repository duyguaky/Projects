
public class Card {
	int id;
	String cardNo;
	
	public Card(int id,String cardNo) {
		this.id = id;
		this.cardNo = cardNo;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}
}
