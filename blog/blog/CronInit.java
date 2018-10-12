package blog;


import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Logger;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.*;
import javax.mail.*;

import static com.googlecode.objectify.ObjectifyService.ofy;
import static javax.mail.Transport.send;

public class CronInit extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(CronInit.class.getName());

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            _logger.info("Cron Init has been executed");
            UserService userService = UserServiceFactory.getUserService();
            User user = userService.getCurrentUser();
            UserEntity userEntity = ofy().load().type(UserEntity.class).filter("email", user.getEmail()).first().now();
            userEntity.setSubscribed(true);
            ofy().save().entity(userEntity).now();

            Properties props = new Properties();
            Session session = Session.getInstance(props, null);

            Message msg = new MimeMessage(session);
            Address from = new InternetAddress("NOREPLY@EE461HW3Blog.appspotmail.com");
            msg.setFrom(from);
            msg.setSubject("Subscribed to Software Lab Reviews!");
//            msg.setSentDate(new Date());
            msg.setText(" Thank you for subscribing to Software Lab Reviews! \n" +
                    "You will now receive a 24-hour digest of the posts on this blog.");
            Address to = new InternetAddress(user.getEmail());
            msg.addRecipient(Message.RecipientType.TO, to);
            send(msg);
        } catch (Exception ex) {
            System.out.println("Send Failed, Exception: " + ex);
        }
        resp.sendRedirect("/index.jsp");
    }
}
