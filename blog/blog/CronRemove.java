package blog;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

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
import static javax.mail.Transport.send;

public class CronRemove extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(CronRemove.class.getName());

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            _logger.info("Cron Init has been executed");
            UserService userService = UserServiceFactory.getUserService();
            User user = userService.getCurrentUser();
            UserEntity userEntity = ofy().load().type(UserEntity.class).filter("email", user.getEmail()).first().now();
            userEntity.setSubscribed(false);
            ofy().save().entity(userEntity).now();

            Properties props = new Properties();
            Session session = Session.getInstance(props, null);

            Message msg = new MimeMessage(session);
            Address from = new InternetAddress("NOREPLY@EE461HW3Blog.appspotmail.com");
            msg.setFrom(from);
            msg.setSubject("Unsubscribed to Software Lab Reviews");
//            msg.setSentDate(new Date());
            msg.setText(" You have now unsubscribed from Software Lab Reviews. \n" +
                    "Thank you for participating! Join again anytime.");
            Address to = new InternetAddress(user.getEmail());
            msg.addRecipient(Message.RecipientType.TO, to);
            send(msg);
        } catch (Exception ex) {
            System.out.println("Send Failed, Exception: " + ex);
        }
        resp.sendRedirect("/index.jsp");
    }
}
