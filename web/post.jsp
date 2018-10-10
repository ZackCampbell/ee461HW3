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
    <title>Write A New Post</title>
</head>
<body>
    <form name="examresultsform" action="examresults" method="post">
        <table>
            <tr>
                <td style="font-weight:bold;">ID Number:</td>
                <td><input name="idnumber"></input></td>
            </tr>
            <tr>
                <td><input type="submit" value="Submit"></td>
                <td><input type="reset" value="Clear"></td>
                <td><input type="reset" value="Cancel"></td>
            </tr>
        </table>
    </form>
</body>
</html>
