package blog;


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
            String userName = request.getParameter("userName");
//            if (userName == null) {
//                userName = "new_user";
//            }
            if (ofy().load().type(UserEntity.class).id(userName) == null) {

            }
            _logger.info("Cron Init has been executed");
            Properties props = new Properties();
            //props.put("mail.smtp.host", "my-mail-server");
            Session session = Session.getInstance(props, null);

            MimeMessage msg = new MimeMessage(session);
            Address from = new InternetAddress("AUTO_BLOG_DIGEST@EE461HW3Blog.appspotmail.com");
            msg.setFrom(from);
            msg.setSubject("Subscribed to Software Lab Reviews!");
            msg.setSentDate(new Date());
            msg.setText(" Thank you for subscribing to Software Lab Reviews! \n" +
                    "You will now recieve a 24-hour digest of the posts on this blog.");
            for (UserEntity userEntity : ofy().load().type(UserEntity.class).list()) {
                if (userEntity.isSubscribed()) {
                    msg.addRecipients(Message.RecipientType.TO, userEntity.getEmail());
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
