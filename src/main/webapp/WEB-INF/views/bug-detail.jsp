<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Bug #${bug.id} - Bug Bounty Lite</title>
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
    <h2>Bug Details</h2>

    <div style="border: 2px solid #007bff; padding: 20px; margin: 20px 0; background-color: #f8f9fa;">
        <h3>Bug #${bug.id}: ${bug.title}</h3>

        <table border="0" cellpadding="5" style="width: 100%;">
            <tr>
                <td style="width: 200px;"><strong>Status:</strong></td>
                <td>
                    <c:choose>
                        <c:when test="${bug.status == 'OPEN'}">
                            <span style="color: blue; font-size: 1.2em; font-weight: bold;">● OPEN</span>
                        </c:when>
                        <c:when test="${bug.status == 'CLAIMED'}">
                            <span style="color: orange; font-size: 1.2em; font-weight: bold;">● CLAIMED</span>
                        </c:when>
                        <c:when test="${bug.status == 'FIXED'}">
                            <span style="color: purple; font-size: 1.2em; font-weight: bold;">● FIXED</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: green; font-size: 1.2em; font-weight: bold;">✓ CLOSED</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <td><strong>Severity:</strong></td>
                <td>
                    <c:choose>
                        <c:when test="${bug.severity == 'CRITICAL'}">
                            <span style="color: red; font-weight: bold; font-size: 1.1em;">🔴 CRITICAL</span>
                        </c:when>
                        <c:when test="${bug.severity == 'HIGH'}">
                            <span style="color: orange; font-weight: bold; font-size: 1.1em;">🟠 HIGH</span>
                        </c:when>
                        <c:when test="${bug.severity == 'MEDIUM'}">
                            <span style="color: #ffc107; font-weight: bold;">🟡 MEDIUM</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: green;">🟢 LOW</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <td><strong>Reported By:</strong></td>
                <td>${bug.reporter.fullName} (${bug.reporter.username})</td>
            </tr>

            <tr>
                <td><strong>Assigned Hunter:</strong></td>
                <td>
                    <c:choose>
                        <c:when test="${bug.assignedHunter != null}">
                            ${bug.assignedHunter.fullName} (${bug.assignedHunter.username})
                        </c:when>
                        <c:otherwise>
                            <em style="color: #999;">Not assigned yet</em>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <td><strong>Affected Module:</strong></td>
                <td>
                    <c:choose>
                        <c:when test="${bug.affectedModule != null && !bug.affectedModule.isEmpty()}">
                            ${bug.affectedModule}
                        </c:when>
                        <c:otherwise>
                            <em style="color: #999;">Not specified</em>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <td><strong>Created At:</strong></td>
                <td>${bug.createdAt.toString().replace('T', ' ')}</td>
            </tr>

            <tr>
                <td><strong>Last Updated:</strong></td>
                <td>${bug.updatedAt.toString().replace('T', ' ')}</td>
            </tr>
        </table>

        <hr>

        <h4>Description:</h4>
        <div style="border: 1px solid #ccc; padding: 15px; background-color: white; white-space: pre-wrap;">
            ${bug.description}
        </div>

        <c:if test="${bug.resolutionNotes != null && !bug.resolutionNotes.isEmpty()}">
            <hr>
            <h4>Resolution Notes:</h4>
            <div style="border: 1px solid #28a745; padding: 15px; background-color: #e8f5e9; white-space: pre-wrap;">
                    ${bug.resolutionNotes}
            </div>
        </c:if>
    </div>

    <!-- Action Buttons (will be implemented in Phase 4) -->
    <div style="margin: 20px 0;">
        <h3>Actions:</h3>

        <c:choose>
            <c:when test="${bug.status == 'OPEN' && sessionScope.role == 'HUNTER'}">
                <p><em>Claim functionality will be available in Phase 4</em></p>
                <!-- <form action="/bugs/${bug.id}/claim" method="post" style="display: inline;">
                <button type="submit">Claim This Bug</button>
                </form> -->
            </c:when>

            <c:when test="${bug.status == 'CLAIMED' && sessionScope.role == 'HUNTER' && bug.assignedHunter.id == sessionScope.userId}">
                <p><em>Mark as Fixed functionality will be available in Phase 4</em></p>
                <!-- <form action="/bugs/${bug.id}/fix" method="post" style="display: inline;">
                <button type="submit">Mark as Fixed</button>
                </form> -->
            </c:when>

            <c:when test="${bug.status == 'FIXED' && sessionScope.role == 'ADMIN'}">
                <p><em>Close Bug functionality will be available in Phase 4</em></p>
                <!-- <form action="/bugs/${bug.id}/close" method="post" style="display: inline;">
                <button type="submit">Close Bug</button>
                </form> -->
            </c:when>

            <c:otherwise>
                <p><em>No actions available for current status and role</em></p>
            </c:otherwise>
        </c:choose>

        <c:if test="${sessionScope.role == 'ADMIN'}">
            <form action="/bugs/${bug.id}/delete" method="post" style="display: inline;"
                  onsubmit="return confirm('Are you sure you want to delete this bug?');">
                <button type="submit" style="background-color: red; color: white;">Delete Bug (Admin)</button>
            </form>
        </c:if>
    </div>

    <div style="margin-top: 30px;">
        <a href="/bugs">← Back to Bug List</a>
    </div>
</main>

<hr>
<footer>
    <p>&copy; 2024 Bug Bounty Lite</p>
</footer>
</body>
</html>