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

public class CronInit extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(CronInit.class.getName());
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            _logger.info("Cron Init has been executed");
            UserService userService = UserServiceFactory.getUserService();
            User user = userService.getCurrentUser();
            String userName = request.getParameter("userName");
            UserEntity userEntity = ofy().load().type(UserEntity.class).filter("email", user.getEmail()).first().now();
            userEntity.setSubscribed(true);
            ofy().save().entity(userEntity).now();

            Properties props = new Properties();
            Session session = Session.getInstance(props, null);

            MimeMessage msg = new MimeMessage(session);
            Address from = new InternetAddress("AUTO_BLOG_DIGEST_NOREPLY@EE461HW3Blog.appspotmail.com");
            msg.setFrom(from);
            msg.setSubject("Subscribed to Software Lab Reviews!");
            msg.setSentDate(new Date());
            msg.setText(" Thank you for subscribing to Software Lab Reviews! \n" +
                    "You will now receive a 24-hour digest of the posts on this blog.");
            Address to = new InternetAddress(ofy().load().type(UserEntity.class).id(userName).now().getEmail());
            msg.addRecipient(Message.RecipientType.TO, to);
            Transport.send(msg);
            response.sendRedirect("/index.jsp");
        } catch (Exception ex) {
            System.out.println("Send Failed, Exception: " + ex);
        }
    }
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doGet(req, resp);
    }
}
