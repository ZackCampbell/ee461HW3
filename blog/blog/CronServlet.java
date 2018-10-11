package blog;

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.*;
import static com.googlecode.objectify.ObjectifyService.ofy;

public class CronServlet extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            _logger.info("Cron Init has been executed");
            Properties props = new Properties();
            props.put("mail.smtp.host", "my-mail-server");
            Session session = Session.getInstance(props, null);

            MimeMessage msg = new MimeMessage(session);
            Address from = new InternetAddress("AUTO_BLOG_DIGEST@461L.com");
            msg.setFrom(from);
            msg.setSubject("Subscribed to Software Lab Reviews!");
            msg.setSentDate(new Date());

            for (MyUser myUser : ofy().load().type(MyUser.class)) {
                if (myUser.isSubscribed()) {
                    msg.addRecipients(Message.RecipientType.TO, myUser.getEmail());
                }
            }
            MimeMultipart parts = new MimeMultipart();
            List<Post> posts = ofy().load().type(Post.class).list();
            Collections.sort(posts);
            Collections.reverse(posts);
            for (Post post : posts) {
                MimeBodyPart userPart = new MimeBodyPart();
                MimeBodyPart titlePart = new MimeBodyPart();
                MimeBodyPart contentPart = new MimeBodyPart();
                userPart.setText(post.userName.getName());
                titlePart.setText(post.getTitle());
                contentPart.setText(post.getContent());
                parts.addBodyPart(userPart);
                parts.addBodyPart(titlePart);
                parts.addBodyPart(contentPart);
                msg.setContent(parts);
            }
            msg.setText(" Thank you for subscribing to Software Lab Reviews! \n" +
                    "You will now recieve a 24-hour digest of the posts on this blog.");
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
