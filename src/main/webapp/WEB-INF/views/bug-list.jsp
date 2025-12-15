<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Bug List - Bug Bounty Lite</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<header>
    <h1>Bug Bounty Lite</h1>
    <nav>
        <a href="/home">Home</a> |
        <a href="/bugs">View Bugs</a> |

        <c:if test="${sessionScope.role == 'REPORTER'}">
            <a href="/bugs/create">Report Bug</a> |
        </c:if>

        <span>Welcome, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.role})</span> |
        <a href="/logout">Logout</a>
    </nav>
</header>

<hr>

<main>
    <h2>Bug List</h2>

    <!-- Filter Options -->
    <div style="border: 1px solid #ccc; padding: 15px; margin: 15px 0; background-color: #f9f9f9;">
        <h3>Filter Bugs:</h3>
        <div>
            <strong>By Status:</strong>
            <a href="/bugs">All</a> |
            <a href="/bugs?status=OPEN">Open</a> |
            <a href="/bugs?status=CLAIMED">Claimed</a> |
            <a href="/bugs?status=FIXED">Fixed</a> |
            <a href="/bugs?status=CLOSED">Closed</a>
        </div>

        <div style="margin-top: 10px;">
            <strong>My Bugs:</strong>
            <c:if test="${sessionScope.role == 'REPORTER'}">
                <a href="/bugs?reportedBy=me">Reported by Me</a>
            </c:if>
            <c:if test="${sessionScope.role == 'HUNTER'}">
                <a href="/bugs?assignedTo=me">Assigned to Me</a>
            </c:if>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="/bugs?reportedBy=me">Reported by Me</a> |
                <a href="/bugs?assignedTo=me">Assigned to Me</a>
            </c:if>
        </div>
    </div>

    <!-- Bug Count -->
    <p><strong>Total Bugs:</strong> ${bugs.size()}</p>

    <!-- Bug Table -->
    <c:choose>
        <c:when test="${empty bugs}">
            <div style="border: 1px solid #ffc107; padding: 20px; margin: 20px 0; background-color: #fff3cd;">
                <p><strong>No bugs found.</strong></p>
                <c:if test="${sessionScope.role == 'REPORTER'}">
                    <p><a href="/bugs/create">Report the first bug</a></p>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <table border="1" cellpadding="10" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                <thead style="background-color: #007bff; color: white;">
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Severity</th>
                    <th>Status</th>
                    <th>Reporter</th>
                    <th>Assigned Hunter</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="bug" items="${bugs}">
                    <tr>
                        <td>${bug.id}</td>
                        <td>
                            <a href="/bugs/${bug.id}">${bug.title}</a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${bug.severity == 'CRITICAL'}">
                                    <span style="color: red; font-weight: bold;">CRITICAL</span>
                                </c:when>
                                <c:when test="${bug.severity == 'HIGH'}">
                                    <span style="color: orange; font-weight: bold;">HIGH</span>
                                </c:when>
                                <c:when test="${bug.severity == 'MEDIUM'}">
                                    <span style="color: #ffc107;">MEDIUM</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: green;">LOW</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${bug.status == 'OPEN'}">
                                    <span style="color: blue;">OPEN</span>
                                </c:when>
                                <c:when test="${bug.status == 'CLAIMED'}">
                                    <span style="color: orange;">CLAIMED</span>
                                </c:when>
                                <c:when test="${bug.status == 'FIXED'}">
                                    <span style="color: purple;">FIXED</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: green;">CLOSED</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${bug.reporter.fullName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${bug.assignedHunter != null}">
                                    ${bug.assignedHunter.fullName}
                                </c:when>
                                <c:otherwise>
                                    <em>Unassigned</em>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                                ${bug.createdAt.toString().substring(0, 16).replace('T', ' ')}
                        </td>
                        <td>
                            <a href="/bugs/${bug.id}">View Details</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</main>

<hr>
<footer>
    <p>&copy; 2024 Bug Bounty Lite</p>
</footer>
</body>
</html>