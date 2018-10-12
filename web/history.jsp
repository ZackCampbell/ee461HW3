<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="java.util.Collections" %>
<%@ page import="blog.Post" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="java.util.Comparator" %>
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

    <%!
        class SortByHighRating implements Comparator<Post> {
            @Override
            public int compare(Post p1, Post p2) {
                return p1.getRating().compareTo(p2.getRating());
            }
        }

        class SortByLowRating implements Comparator<Post> {
            @Override
            public int compare(Post p1, Post p2) {
                return p2.getRating().compareTo(p1.getRating());
            }
        }

        class SortByDate implements Comparator<Post> {
            @Override
            public int compare(Post p1, Post p2) {
                if (p1.getDate().after(p2.getDate()))
                    return -1;
                else if (p1.getDate().before(p2.getDate()))
                    return 1;
                return 0;
            }
        }
    %>

    <table>
        <tr>
            <td>
                <form name="backform" action="/index.jsp">
                    <input type="submit" value="Back to Home">
                </form>
            </td>
            <td><form action="/history.jsp"><input type="hidden" name="order" value="date"><input type="submit" value="Order Newest to Oldest"></form></td>
            <td><form action="/history.jsp"><input type="hidden" name="order" highRating"><input type="submit" value="Order by Highest Rating"></form></td>
            <td><form action="/history.jsp"><input type="hidden" name="order" value="lowRating"><input type="submit" value="Order by Lowest Rating"></form></td>
        </tr>
    </table>

<%
    String userName = request.getParameter("userName");
    String order = request.getParameter("order");
    pageContext.setAttribute("userName", userName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null)
        pageContext.setAttribute("user", user);

    ObjectifyService.register(Post.class);
    List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();
    if (order == null)
        order = "date";
    switch (order) {
        case "highRating" :
            try {
                Collections.sort(posts, new SortByHighRating());
            } catch (Exception e) {}
            break;
        case "lowRating" :
            try {
                Collections.sort(posts, new SortByLowRating());
            } catch (Exception e) {}
            break;
        case "date" :
            try {
                Collections.sort(posts, new SortByDate());
            } catch (Exception e) {}
            break;
    }

    if (posts.isEmpty()) {

%>

<p>There are no posts available.</p>

<%  } else {

    for (Post post : posts) {

        pageContext.setAttribute("post_content", post.getContent());
        pageContext.setAttribute("post_user", post.getUser());
        pageContext.setAttribute("post_title", post.getTitle());
        pageContext.setAttribute("post_date", post.getDate());
        pageContext.setAttribute("post_rating", post.getRating());
%>

<p><i>${fn:escapeXml(post_user.nickname)}</i> wrote on ${fn:escapeXml(post_date)}:</p>
    <h3>Rating: ${fn:escapeXml(post_rating)}/5</h3>
    <h3><b>"${fn:escapeXml(post_title)}"</b></h3>
    <blockquote>${fn:escapeXml(post_content)}</blockquote>

<% }
}
%>

</body>
</html>
