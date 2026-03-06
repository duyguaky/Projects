import java.awt.EventQueue;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class UserInfoScreen extends JFrame {

    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private JTextField textName;
    private JLabel lblTckn;
    private JTextField textTckn;
    private JLabel lblPhoneNumber;
    private JTextField textPhoneNumber;
    private JLabel lblAddress;
    private JTextField textAddress;
    private JLabel lblBirthDate;
    private JTextField textBirthDate;
    private JLabel lblWallet;
    private JTextField textWalletBalance;
    private JLabel lblCreditCard;
    private JTextField textCreditCardNo;
    private JLabel lblCardDebt;
    private JTextField textCardDebt;
    private JLabel lblBankCardNo;
    private JTextField textBankCardNo;
    private JLabel lblBankCardBalance;
    private JTextField textBankCardBalance;
    private JLabel lblTransportationCard;
    private JTextField textTransportationCardNo;
    private JLabel lblBakiye;
    private JTextField textTransportationCardBalance;
    private JLabel lblTransportationCardCity;
    private JTextField textCity;
    private JTextField textSendMoney;
    private JButton btnSendMoney;
    private JLabel lblSendMoneyInfo;
    private JTextField textIBAN;
    private JLabel lblIBANNo;

    /**
     * Launch the application.
     */
    public static void main(String[] args) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    UserInfoScreen frame = new UserInfoScreen(null, null, null, null, null);
                    frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Create the frame.
     */
    public UserInfoScreen(User user, Wallet wallet, CreditCard creditCard, BankCard bankCard, TransportationCard transportationCard) {
        setTitle("Kullanıcı Bilgileri");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 450, 450);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

        setContentPane(contentPane);
        
        if(user == null)
            return;
        contentPane.setLayout(null);
    
        JLabel lblName = new JLabel("İsim");
        lblName.setBounds(24, 15, 27, 16);
        contentPane.add(lblName);
        
        textName = new JTextField();
        textName.setBounds(56, 10, 370, 26);
        textName.setEditable(false);
        contentPane.add(textName);
        textName.setColumns(30);
        textName.setText(user.name);
        
        lblTckn = new JLabel("TCKN:");
        lblTckn.setBounds(18, 46, 39, 16);
        contentPane.add(lblTckn);
        
        textTckn = new JTextField();
        textTckn.setBounds(62, 41, 370, 26);
        textTckn.setEditable(false);
        contentPane.add(textTckn);
        textTckn.setColumns(30);
        textTckn.setText(user.tckn);
        
        lblPhoneNumber = new JLabel("Telefon");
        lblPhoneNumber.setBounds(14, 77, 47, 16);
        contentPane.add(lblPhoneNumber);
        
        textPhoneNumber = new JTextField();
        textPhoneNumber.setBounds(66, 72, 370, 26);
        contentPane.add(textPhoneNumber);
        textPhoneNumber.setColumns(30);
        textPhoneNumber.setText(user.phoneNumber);
        
        lblAddress = new JLabel("Adres");
        lblAddress.setBounds(19, 108, 36, 16);
        contentPane.add(lblAddress);
        
        textAddress = new JTextField();
        textAddress.setBounds(60, 103, 370, 26);
        contentPane.add(textAddress);
        textAddress.setColumns(30);
        textAddress.setText(user.address);
        
        lblBirthDate = new JLabel("Doğum Tarihi");
        lblBirthDate.setBounds(18, 139, 86, 16);
        contentPane.add(lblBirthDate);
        
        textBirthDate = new JTextField();
        textBirthDate.setBounds(109, 134, 322, 26);
        contentPane.add(textBirthDate);
        textBirthDate.setColumns(26);
        textBirthDate.setText(user.birthdate.toString());
        
        lblWallet = new JLabel("Cüzdan Bakiye");
        lblWallet.setBounds(16, 170, 91, 16);
        contentPane.add(lblWallet);
        
        textWalletBalance = new JTextField();
        textWalletBalance.setBounds(112, 165, 322, 26);
        textWalletBalance.setEditable(false);
        contentPane.add(textWalletBalance);
        textWalletBalance.setColumns(26);
        textWalletBalance.setText(String.valueOf(wallet.balance));
        
        lblCreditCard = new JLabel("Kredi Kart No");
        lblCreditCard.setBounds(13, 201, 83, 16);
        contentPane.add(lblCreditCard);
        
        textCreditCardNo = new JTextField();
        textCreditCardNo.setBounds(101, 196, 130, 26);
        textCreditCardNo.setEditable(false);
        contentPane.add(textCreditCardNo);
        textCreditCardNo.setColumns(10);
        textCreditCardNo.setText(creditCard.cardNo);
        
        lblCardDebt = new JLabel("Borç tutarı");
        lblCardDebt.setBounds(236, 201, 65, 16);
        contentPane.add(lblCardDebt);
        
        textCardDebt = new JTextField();
        textCardDebt.setBounds(306, 196, 130, 26);
        textCardDebt.setEditable(false);
        contentPane.add(textCardDebt);
        textCardDebt.setColumns(10);
        textCardDebt.setText(String.valueOf(creditCard.debtBalance));
        
        lblBankCardNo = new JLabel("Banka Kart No");
        lblBankCardNo.setBounds(23, 232, 88, 16);
        contentPane.add(lblBankCardNo);
        
        textBankCardNo = new JTextField();
        textBankCardNo.setBounds(116, 227, 130, 26);
        textBankCardNo.setEditable(false);
        contentPane.add(textBankCardNo);
        textBankCardNo.setColumns(10);
        textBankCardNo.setText(bankCard.cardNo);
        
        lblBankCardBalance = new JLabel("Bakiye");
        lblBankCardBalance.setBounds(251, 232, 40, 16);
        contentPane.add(lblBankCardBalance);
        
        textBankCardBalance = new JTextField();
        textBankCardBalance.setBounds(296, 227, 130, 26);
        textBankCardBalance.setEditable(false);
        contentPane.add(textBankCardBalance);
        textBankCardBalance.setColumns(10);
        textBankCardBalance.setText(String.valueOf(bankCard.balance));
        
        lblTransportationCard = new JLabel("Ulaşım Kart No");
        lblTransportationCard.setBounds(20, 263, 94, 16);
        contentPane.add(lblTransportationCard);
        
        textTransportationCardNo = new JTextField();
        textTransportationCardNo.setBounds(119, 258, 130, 26);
        contentPane.add(textTransportationCardNo);
        textTransportationCardNo.setColumns(10);
        textTransportationCardNo.setText(transportationCard.cardNo);
        
        lblBakiye = new JLabel("Bakiye");
        lblBakiye.setBounds(254, 263, 40, 16);
        contentPane.add(lblBakiye);
        
        textTransportationCardBalance = new JTextField();
        textTransportationCardBalance.setBounds(299, 258, 130, 26);
        textTransportationCardBalance.setEditable(false);
        contentPane.add(textTransportationCardBalance);
        textTransportationCardBalance.setColumns(10);
        textTransportationCardBalance.setText(String.valueOf(transportationCard.balance));
        
        lblTransportationCardCity = new JLabel("Ulaşım kartı tipi(Şehir)");
        lblTransportationCardCity.setBounds(15, 294, 140, 16);
        contentPane.add(lblTransportationCardCity);
        
        textCity = new JTextField();
        textCity.setBounds(160, 289, 274, 26);
        textCity.setEditable(false);
        contentPane.add(textCity);
        textCity.setColumns(22);
        textCity.setText(transportationCard.city);
        
        textSendMoney = new JTextField();
        textSendMoney.setBounds(13, 361, 190, 26);
        contentPane.add(textSendMoney);
        textSendMoney.setColumns(15);
        
        btnSendMoney = new JButton("Cüzdandan Para Gönder");
        btnSendMoney.setBounds(216, 361, 193, 29);
        btnSendMoney.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                int sendMoneyValue = Integer.parseInt(textSendMoney.getText());
                int wBalance = Integer.parseInt(textWalletBalance.getText());
                if(sendMoneyValue <= wBalance) {
                    int remainingBalance = wBalance - sendMoneyValue;
                    textWalletBalance.setText(String.valueOf(remainingBalance));
                    lblSendMoneyInfo.setText(String.valueOf(sendMoneyValue) + " TL başarılı gönderildi. Kalan bakiye: " + String.valueOf(remainingBalance));
                } else {
                    lblSendMoneyInfo.setText("Cüzdan bakiyesi yetersiz");
                }
            }
        });
        contentPane.add(btnSendMoney);
        lblSendMoneyInfo = new JLabel("");
        lblSendMoneyInfo.setBounds(13, 390, 400, 16);
        contentPane.add(lblSendMoneyInfo);
        
        textIBAN = new JTextField();
        textIBAN.setColumns(15);
        textIBAN.setBounds(216, 323, 190, 26);
        contentPane.add(textIBAN);
        
        lblIBANNo = new JLabel("IBAN No");
        lblIBANNo.setBounds(25, 327, 140, 16);
        contentPane.add(lblIBANNo);
    }
}
