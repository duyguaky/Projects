import java.time.LocalDate;

public class Main {

	public static void main(String[] args) {
	
        
        User user = new User(1,"ali", "5332125454", "353","istanbul","sifre", LocalDate.now());
        user.checkPhoneNumberAndPassword("5332125454","sifre");
        user.showUserInfo();
        CreditCard creditCard= new CreditCard(1,"45632865",25);
        creditCard.showcreditcardInfo();
	}
	
}
