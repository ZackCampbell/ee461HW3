package blog;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import static com.googlecode.objectify.ObjectifyService.ofy;

public class BlogServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String userName = request.getParameter("userName");
        String content = request.getParameter("content");
        String title = request.getParameter("title");
        Post post = new Post(user, content, userName, title);
//        MyUser myUser = new MyUser(userName);


        ofy().save().entity(post).now();   // synchronous
//        ofy().save().entity(myUser).now();

        response.sendRedirect("/history.jsp?name=" + userName);
    }
}
