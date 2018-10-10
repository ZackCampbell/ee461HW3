<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="java.util.Collections" %>
<%@ page import="blog.Post" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%--
  Created by IntelliJ IDEA.
  User: audre
  Date: 10/9/2018
  Time: 6:56 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="blogstyle.css">
    <title>Here are all the posts from this blog:</title>
</head>
<body>
    <h1>History of all posts:</h1><br>
    <form name="postform" action="/index.jsp">
        <input type="submit" value="Back to Home">
    </form>
<%
    String userName = request.getParameter("userName");
    pageContext.setAttribute("userName", userName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null)
        pageContext.setAttribute("user", user);

    ObjectifyService.register(Post.class);
    List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();
    Collections.sort(posts);
    Collections.reverse(posts);
    if (posts.isEmpty()) {

%>

<p>'${fn:escapeXml(userName)}' has no messages.</p>

<%  } else {

    for (Post post : posts) {

        pageContext.setAttribute("post_content", post.getContent());
        pageContext.setAttribute("post_user", post.getUser());
        pageContext.setAttribute("post_title", post.getTitle());
        pageContext.setAttribute("post_date", post.getDate());
%>

<p><i>${fn:escapeXml(post_user.nickname)}</i> wrote on ${fn:escapeXml(post_date)}:</p>
    <blockquote><b style="font-family: 'Book Antiqua'">${fn:escapeXml(post_title)}</b></blockquote>
    <blockquote>${fn:escapeXml(post_content)}</blockquote>

<% }
}
%>

</body>
</html>
