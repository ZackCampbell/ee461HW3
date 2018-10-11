<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="blog.Post" %>
<%@ page import="java.util.Collections" %>
<%@ page import="static com.googlecode.objectify.ObjectifyService.ofy" %>
<%@ page import="blog.MyUser" %>
<%--
  Created by IntelliJ IDEA.
  User: Vixon
  Date: 10/9/2018
  Time: 6:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
  <link rel="stylesheet" href="blogstyle.css">
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <title>Software Lab Blog</title>
</head>
<body>
<h1>Software Lab Reviews!</h1><br>
<img src="http://blog.reship.com/wp-content/uploads/2016/06/Best-Product-Review-Sites.jpg"><br>

<%!
    public void subscribe(String userName, String email) {
        MyUser currUser = ofy().load().type(MyUser.class).id(userName).now();
        currUser.setSubscribed(true);
        currUser.setEmail(email);
        ofy().save().entity(currUser).now();
    }
    public void unsubscribe(String userName) {
        MyUser currUser = ofy().load().type(MyUser.class).id(userName).now();
        currUser.setSubscribed(false);
        ofy().save().entity(currUser).now();
    }
%>

<%
    String userName = request.getParameter("userName");
    boolean test = true;
    if (userName == null) {
        userName = "default";

    }

    pageContext.setAttribute("userName", userName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null) {

        pageContext.setAttribute("user", user);
        pageContext.setAttribute("userName", user.getNickname());
        System.out.println(user.getNickname());

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a> or

    <% if (!ofy().load().type(MyUser.class).id(userName).now().isSubscribed()) { %>

    <a href="/croninit" onclick="<%= subscribe(userName, user.getEmail()) %>">Subscribe</a>)

    <% } else { %>

    <a href="/cronremove" onclick="<%= unsubscribe(userName) %>">Unsubscribe</a>)

    <% } %>

</p>
<form action="post.jsp">
    <input type="submit" value="Create a New Post">
</form>

<% } else { %>

<p>Hello!

    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

    to make a new post.</p>

<% } %>

<form action="history.jsp">
  <input type="submit" value="See All Posts">
</form>

<%
    ObjectifyService.register(Post.class);
    List<Post> posts = ofy().load().type(Post.class).list();
    Collections.sort(posts);
    Collections.reverse(posts);
    if (posts.isEmpty()) {

%>

<p>'${fn:escapeXml(userName)}' has no messages.</p>

<%  } else {
        int n = 4;
        if (posts.size() == 1) {
            n = 1;
        } else if (posts.size() == 2) {
            n = 2;
        } else if (posts.size() == 3) {
            n = 3;
        }
        for (int i = 0; i < n; i++) {
            pageContext.setAttribute("post_content", posts.get(i).getContent());
            pageContext.setAttribute("post_user", posts.get(i).getUser());
            pageContext.setAttribute("post_title", posts.get(i).getTitle());
            pageContext.setAttribute("post_date", posts.get(i).getDate());
%>

<p><i>${fn:escapeXml(post_user.nickname)}</i> wrote:</p>
<blockquote><b style="font-family: 'Book Antiqua'">${fn:escapeXml(post_title)}</b></blockquote>
<blockquote>${fn:escapeXml(post_content)}</blockquote>

<%      }
    }
%>

</body>
</html>
