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
import static javax.mail.Transport.send;

public class CronServlet extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            List<Post> posts = ofy().load().type(Post.class).list();
            if (posts.isEmpty()) {
                _logger.info("No Posts in the last 24 hours");
                return;
            }
            _logger.info("Cron Init has been executed");
            Properties props = new Properties();
            Session session = Session.getInstance(props, null);

            Message msg = new MimeMessage(session);
            Address from = new InternetAddress("AUTO_BLOG_DIGEST_NOREPLY@EE461HW3Blog.appspotmail.com");
            msg.setFrom(from);
            msg.setSubject("Subscribed to Software Lab Reviews!");
            Date date = new Date();
            msg.setSentDate(date);

            for (UserEntity userEntity : ofy().load().type(UserEntity.class)) {
                if (userEntity.isSubscribed()) {
                    Address to = new InternetAddress(userEntity.getEmail());
                    msg.addRecipient(Message.RecipientType.TO, to);
                }
            }
            msg.setText(" Thank you for subscribing to Software Lab Reviews! \n" +
                    "You will now receive a 24-hour digest of the posts on this blog.");

            MimeMultipart parts = new MimeMultipart();
            Collections.sort(posts);
            Collections.reverse(posts);
            for (Post post : posts) {
                if (post.getDate().getTime() >= date.getTime() - 86400000) {
                    MimeBodyPart userPart = new MimeBodyPart();
                    MimeBodyPart titlePart = new MimeBodyPart();
                    MimeBodyPart contentPart = new MimeBodyPart();
                    userPart.setText(post.postName.getName());
                    titlePart.setText(post.getTitle());
                    contentPart.setText(post.getContent());
                    parts.addBodyPart(userPart);
                    parts.addBodyPart(titlePart);
                    parts.addBodyPart(contentPart);
                }
            }
            msg.setContent(parts);
            send(msg);
        } catch (Exception ex) {
            System.out.println("Send Failed, Exception: " + ex);
        }
    }
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doGet(req, resp);
    }
}
