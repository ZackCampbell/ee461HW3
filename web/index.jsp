<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="blog.Post" %>
<%@ page import="java.util.Collections" %>
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
<h1>Welcome To Our Blog!</h1><br>

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

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a> or

    <% if (test) { %>

    <a href="">Subscribe</a>)       <!-- SET SUBSCRIBED TO TRUE HERE -->

    <% } else { %>

    <a href="">Unsubscribe</a>)

    <% } %>

</p>
<form action="post.jsp">
    <input type="submit" value="Create a New blog.Post">
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
    List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();
    Collections.sort(posts);

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
        for (int i = posts.size() - n; i < posts.size(); i++) {
            pageContext.setAttribute("post_content", posts.get(i).getContent());
            pageContext.setAttribute("post_user", posts.get(i).getUser());
%>

<p><b>${fn:escapeXml(post_user.nickname)}</b> wrote:</p>
<blockquote>${fn:escapeXml(post_content)}</blockquote>

<%      }
    }
%>

</body>
</html>
