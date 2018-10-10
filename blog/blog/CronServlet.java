package blog;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.http.*;
@SuppressWarnings("serial")
public class CronServlet extends HttpServlet {
    private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            _logger.info("Cron Job has been executed");
//Put your logic here
//BEGIN


//END
        } catch (Exception ex) {
        }
    }
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doGet(req, resp);
    }
}
