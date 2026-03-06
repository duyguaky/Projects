import java.awt.EventQueue;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.SwingConstants;
import javax.swing.JTextField;
import javax.swing.JButton;
import javax.swing.JPasswordField;
import java.awt.event.ActionListener;
import java.time.LocalDate;
import java.awt.event.ActionEvent;
import java.awt.FlowLayout;

public class UserScreen extends JFrame {

    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private JTextField textPhoneNumber;
    private JPasswordField textPassword;
    private final JButton btnLogin = new JButton("Giriş");
    private JLabel lblInfo;

    /**
     * Launch the application.
     */
    public static void main(String[] args) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    UserScreen frame = new UserScreen();
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
    public UserScreen() {
        setTitle("Cüzdan Giriş Ekranı");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 450, 300);
        contentPane = new JPanel();
        FlowLayout flowLayout = (FlowLayout) contentPane.getLayout();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        
        JLabel lblPhoneNumber = new JLabel("Telefon Numarası:");
        contentPane.add(lblPhoneNumber);
        
        textPhoneNumber = new JTextField();
        contentPane.add(textPhoneNumber);
        textPhoneNumber.setColumns(10);
        
        JLabel lblPassword = new JLabel("Şifre:");
        contentPane.add(lblPassword);
        
        textPassword = new JPasswordField();
        contentPane.add(textPassword);
        textPassword.setColumns(10);
        
        btnLogin.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String userPhoneNumber = textPhoneNumber.getText();
                String userPassword = new String(textPassword.getPassword());
                User user = new User(1,"ali", "1234", "353","istanbul","sifre", LocalDate.now());
                Wallet wallet = new Wallet(1,100,1);
                CreditCard creditCard = new CreditCard(1,"1234****5678",25);
                BankCard bankCard = new BankCard(2,"5456****8787",250);
                TransportationCard transportationCard = new TransportationCard(3,"4545****7898",80,"İstanbul");
                String result = user.checkPhoneNumberAndPassword(userPhoneNumber,userPassword);
                lblInfo.setText(result);
                if(result.equals("telefon ve şifre eşleşti"))
                {
                    UserInfoScreen dialog = new UserInfoScreen(user,wallet,creditCard,bankCard,transportationCard); 
                    dialog.setVisible(true);
                }
            }
        });
        contentPane.add(btnLogin);
        
        lblInfo = new JLabel("");
        contentPane.add(lblInfo);
    }
}
