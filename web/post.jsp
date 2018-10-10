<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: audre
  Date: 10/9/2018
  Time: 7:00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="blogstyle.css">
    <title>Write A New blog.Post</title>
</head>
<body>
<%
    String userName = request.getParameter("userName");
    if (userName == null) {
        userName = "default";
    }
    pageContext.setAttribute("userName", userName);
%>
    <form name="postform" action="/ofyblog" method="post">
        <table>
            <tr>
                <td style="font-weight:bold;"><input type="text" name="title" size="35" placeholder="Title"></td>
            </tr>
            <tr>
                <td><textarea rows="8" cols="50" placeholder="Write your content here..."></textarea></td>
            </tr>
            <tr>
                <td><input type="submit" value="Submit"><a href="index.jsp" style="padding-left: auto"><input type="button" value="Cancel"></a></td>
            </tr>
            <tr>
                <input type="hidden" name="userName" value="${fn:escapeXml(userName)}"/>
            </tr>
        </table>
    </form>
</body>
</html>
