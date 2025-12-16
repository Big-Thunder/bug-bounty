<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Bug Bounty Lite</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<h1>Bug Bounty Lite</h1>
<h2>Login</h2>

<c:if test="${not empty error}">
    <div style="color: red; border: 1px solid red; padding: 10px; margin: 10px 0;">
            ${error}
    </div>
</c:if>

<c:if test="${not empty success}">
    <div style="color: green; border: 1px solid green; padding: 10px; margin: 10px 0;">
            ${success}
    </div>
</c:if>

<form action="/login" method="post">
    <div>
        <label for="username">Username:</label><br>
        <input type="text" id="username" name="username" required>
    </div>

    <div>
        <label for="password">Password:</label><br>
        <input type="password" id="password" name="password" required>
    </div>

    <div>
        <button type="submit">Login</button>
    </div>
</form>

<p>Don't have an account? <a href="/register">Register here</a></p>
</body>
</html>