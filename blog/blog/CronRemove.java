package blog;

import java.io.IOException;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Logger;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.*;
import static com.googlecode.objectify.ObjectifyService.ofy;

public class CronRemove extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(CronRemove.class.getName());
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            _logger.info("Cron Init has been executed");
            Properties props = new Properties();
            props.put("mail.smtp.host", "my-mail-server");
            Session session = Session.getInstance(props, null);

            MimeMessage msg = new MimeMessage(session);
            Address from = new InternetAddress("AUTO_BLOG_DIGEST@461L.com");
            msg.setFrom(from);
            msg.setSubject("Unsubscribed to Software Lab Reviews");
            msg.setSentDate(new Date());
            msg.setText(" You have now unsubscribed from Software Lab Reviews. \n" +
                    "Thank you for participating! Join again anytime.");
            for (MyUser myUser : ofy().load().type(MyUser.class).list()) {
                if (myUser.isSubscribed()) {
                    msg.addRecipients(Message.RecipientType.TO, myUser.getEmail());
                }
            }
            Transport.send(msg);
        } catch (Exception ex) {
            System.out.println("Send Failed, Exception: " + ex);
        }
    }
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doGet(req, resp);
    }
}
