<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Bug Bounty Lite</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<h1>Bug Bounty Lite</h1>
<h2>Register New Account</h2>

<c:if test="${not empty error}">
    <div style="color: red; border: 1px solid red; padding: 10px; margin: 10px 0;">
            ${error}
    </div>
</c:if>

<form action="/register" method="post">
    <div>
        <label for="username">Username:</label><br>
        <input type="text" id="username" name="username" required minlength="3" maxlength="50">
        <small>3-50 characters</small>
    </div>

    <div>
        <label for="email">Email:</label><br>
        <input type="email" id="email" name="email" required>
    </div>

    <div>
        <label for="fullName">Full Name:</label><br>
        <input type="text" id="fullName" name="fullName" required maxlength="100">
    </div>

    <div>
        <label for="password">Password:</label><br>
        <input type="password" id="password" name="password" required minlength="6">
        <small>Minimum 6 characters</small>
    </div>

    <div>
        <label for="confirmPassword">Confirm Password:</label><br>
        <input type="password" id="confirmPassword" name="confirmPassword" required>
    </div>

    <div>
        <label for="role">Role:</label><br>
        <select id="role" name="role" required>
            <option value="">-- Select Role --</option>
            <option value="REPORTER">Reporter (Report bugs)</option>
            <option value="HUNTER">Hunter (Fix bugs)</option>
        </select>
    </div>

    <div>
        <button type="submit">Register</button>
    </div>
</form>

<p>Already have an account? <a href="/login">Login here</a></p>
</body>
</html>