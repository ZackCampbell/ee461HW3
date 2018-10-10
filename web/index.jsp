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

    if (userName == null) {
        // TODO
        userName = "unavailable";

    }

    pageContext.setAttribute("userName", userName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

        pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign out</a>.)</p>

<%

} else {

%>

<p>Hello!

    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

    to make a new post.</p>

<%

    }

%>


<%
    if (!userName.equals("unavailable")) {

%>

<form action="post.jsp">
  <input type="submit" value="Create a New Post">
</form>

<%
    }
%>

<form action="history.jsp">
  <input type="submit" value="See All Posts">
</form>

</body>
</html>
