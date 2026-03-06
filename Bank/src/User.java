import java.time.LocalDate;

public class User {
	 // Fields
    int id;
    String name;
    String phoneNumber;
    String tckn;
    String address;
    String password;
    LocalDate birthdate; 
    
    public User(int id,String name, String phoneNumber,String tckn, String address, String password, LocalDate birthdate) {
    	this.id = id;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.tckn = tckn;
        this.address = address;
        this.password = password;
        this.birthdate = birthdate;
    }
    
    public String checkPhoneNumberAndPassword(String phoneNum, String pass) {
    	if(phoneNum.equals(phoneNumber) & pass.equals(password)) {
    		return "telefon ve şifre eşleşti";
    	}
    	else {
    		return "telefon ve şifre hatalı";
    	}
    }
    
    public void showUserInfo()
    {
    	System.out.println("İsim:" + name);
    	System.out.println("Tel No:" + phoneNumber);
    	System.out.println("Tckn:" + tckn);
    	System.out.println("Adres:" + address);
    	System.out.println("Doğum Tarihi:" + birthdate);
    }
        
}
