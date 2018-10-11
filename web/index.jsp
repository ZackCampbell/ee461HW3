<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="blog.Post" %>
<%@ page import="java.util.Collections" %>
<%@ page import="static com.googlecode.objectify.ObjectifyService.ofy" %>
<%@ page import="blog.UserEntity" %>
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
<h1>Software Lab Reviews</h1><br>
<h2>Read what your peers have to say about the class!</h2><br>
<img src="http://blog.reship.com/wp-content/uploads/2016/06/Best-Product-Review-Sites.jpg"><br>

<%
    String userName = request.getParameter("userName");
    ObjectifyService.register(UserEntity.class);
    if (userName == null) {
        userName = "default";

    }

    pageContext.setAttribute("userName", userName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null) {

        pageContext.setAttribute("user", user);

        UserEntity userEntity = new UserEntity(user, userName, user.getEmail());
        if (!ofy().load().type(UserEntity.class).list().contains(userEntity)) {
            ofy().save().entity(userEntity).now();
        }
        UserEntity testUser = ofy().load().type(UserEntity.class).filter("email", user.getEmail()).first().now();
        if (testUser == null) {
            System.out.println("testUser is null");
        }
//        List<UserEntity> users = ofy().load().type(UserEntity.class).list();
//        System.out.println("Current Database:");
//        for (UserEntity u : users) {
//            System.out.println(u.getEmail());
//        }

        boolean isSubscribed = testUser.isSubscribed();

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>)</p>

    <% if (!isSubscribed) { %>

    <form action="/croninit" method="post">
        <input type="hidden" name="userName" value="<%= pageContext.getAttribute("userName") %>">
        <input type="hidden" name="email" value="<%= user.getEmail() %>">
        <input type="submit" value="Subscribe">
    </form>

    <% } else { %>

    <form action="/cronremove" method="post">
        <input type="hidden" name="userName" value="<%= pageContext.getAttribute("userName") %>">
        <input type="hidden" name="email" value="<%= user.getEmail() %>">
        <input type="submit" value="Unsubscribe">
    </form>

    <% } %>
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

<p>There are no posts available.</p>

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
            pageContext.setAttribute("post_rating", posts.get(i).getRating());
%>

<p><i>${fn:escapeXml(post_user.nickname)}</i> wrote on ${fn:escapeXml(post_date)}:</p>
<h3>Rating: ${fn:escapeXml(post_rating)}/Five</h3>
<h3><b>"${fn:escapeXml(post_title)}"</b></h3>
<blockquote>${fn:escapeXml(post_content)}</blockquote>

<%      }
    }
%>

</body>
</html>
