<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home - Bug Bounty Lite</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<header>
    <h1>Bug Bounty Lite</h1>
    <nav>
        <a href="/home">Home</a> |
        <a href="/bugs">View Bugs</a> |

        <c:if test="${sessionScope.role == 'REPORTER' || sessionScope.role == 'ADMIN'}">
            <a href="/bugs/create">Report Bug</a> |
        </c:if>

        <span>Welcome, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.role})</span> |
        <a href="/logout">Logout</a>
    </nav>
</header>

<hr>

<main>
    <h2>Welcome to Bug Bounty Lite</h2>

    <div style="border: 1px solid #ccc; padding: 20px; margin: 20px 0; background-color: #f9f9f9;">
        <h3>Your Profile</h3>
        <p><strong>Username:</strong> ${sessionScope.user.username}</p>
        <p><strong>Full Name:</strong> ${sessionScope.user.fullName}</p>
        <p><strong>Email:</strong> ${sessionScope.user.email}</p>
        <p><strong>Role:</strong> ${sessionScope.role.displayName}</p>
    </div>

    <div style="border: 1px solid #007bff; padding: 20px; margin: 20px 0; background-color: #e7f3ff;">
        <h3>Quick Actions</h3>

        <c:choose>
            <c:when test="${sessionScope.role == 'ADMIN'}">
                <ul>
                    <li><a href="/bugs">View All Bugs</a></li>
                    <li><a href="/bugs?status=FIXED">Review Fixed Bugs</a></li>
                    <li><strong>Admin privilege:</strong> Close verified bugs</li>
                </ul>
            </c:when>

            <c:when test="${sessionScope.role == 'HUNTER'}">
                <ul>
                    <li><a href="/bugs">View All Bugs</a></li>
                    <li><a href="/bugs?status=OPEN">Claim Open Bugs</a></li>
                    <li><a href="/bugs?assignedTo=me">My Assigned Bugs</a></li>
                    <li><strong>Hunter privilege:</strong> Claim and fix bugs</li>
                </ul>
            </c:when>

            <c:when test="${sessionScope.role == 'REPORTER'}">
                <ul>
                    <li><a href="/bugs">View All Bugs</a></li>
                    <li><a href="/bugs/create">Report New Bug</a></li>
                    <li><a href="/bugs?reportedBy=me">My Reported Bugs</a></li>
                    <li><strong>Reporter privilege:</strong> Report new bugs</li>
                </ul>
            </c:when>
        </c:choose>
    </div>

    <div style="border: 1px solid #28a745; padding: 20px; margin: 20px 0; background-color: #e8f5e9;">
        <h3>System Information</h3>
        <p><strong>Bug Workflow:</strong> OPEN → CLAIMED → FIXED → CLOSED</p>
        <p><strong>Roles:</strong></p>
        <ul>
            <li><strong>Reporter:</strong> Can create and view bugs</li>
            <li><strong>Hunter:</strong> Can claim bugs and mark them as fixed</li>
            <li><strong>Admin:</strong> Can manage all bugs and close verified issues</li>
        </ul>
    </div>
</main>

<hr>
<footer>
    <p>&copy; 2024 Bug Bounty Lite | Session-based Authentication</p>
</footer>
</body>
</html>