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

    <c:if test="${not empty sessionScope.error}">
        <div style="color: red; border: 1px solid red; padding: 10px; margin: 10px 0; background-color: #ffe6e6;">
            <strong>Error:</strong> ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

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

    <!-- Action Buttons -->
    <div style="margin: 20px 0;">
        <h3>Actions:</h3>

        <c:if test="${not empty error}">
            <div style="color: red; border: 1px solid red; padding: 10px; margin: 10px 0; background-color: #ffe6e6;">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>

        <c:choose>
            <%-- HUNTER can claim OPEN bugs --%>
            <c:when test="${bug.status == 'OPEN' && sessionScope.role == 'HUNTER'}">
                <form action="/bugs/${bug.id}/claim" method="post" style="display: inline;">
                    <button type="submit" style="padding: 10px 20px; background-color: #007bff; color: white; border: none; cursor: pointer; font-size: 16px;">
                        🎯 Claim This Bug
                    </button>
                </form>
                <p><em>Click to claim this bug and start working on it</em></p>
            </c:when>

            <%-- HUNTER can mark CLAIMED bugs as FIXED (if assigned to them) --%>
            <c:when test="${bug.status == 'CLAIMED' && sessionScope.role == 'HUNTER' && bug.assignedHunter.id == sessionScope.userId}">
                <form action="/bugs/${bug.id}/fix" method="post" style="margin-top: 10px;">
                    <label for="resolutionNotes"><strong>Resolution Notes:</strong> <span style="color: red;">*</span></label><br>
                    <textarea id="resolutionNotes" name="resolutionNotes" required
                              style="width: 100%; max-width: 600px; padding: 8px; font-size: 14px; min-height: 100px; margin-top: 5px;"
                              placeholder="Describe the fix you implemented..."></textarea>
                    <br>
                    <button type="submit" style="padding: 10px 20px; background-color: #28a745; color: white; border: none; cursor: pointer; font-size: 16px; margin-top: 10px;">
                        ✅ Mark as Fixed
                    </button>
                </form>
                <p><em>Provide details about the fix before marking as fixed</em></p>
            </c:when>

            <%-- ADMIN can close FIXED bugs --%>
            <c:when test="${bug.status == 'FIXED' && sessionScope.role == 'ADMIN'}">
                <form action="/bugs/${bug.id}/close" method="post" style="margin-top: 10px;">
                    <label for="verificationNotes"><strong>Verification Notes:</strong> (Optional)</label><br>
                    <textarea id="verificationNotes" name="verificationNotes"
                              style="width: 100%; max-width: 600px; padding: 8px; font-size: 14px; min-height: 80px; margin-top: 5px;"
                              placeholder="Add verification notes (optional)..."></textarea>
                    <br>
                    <button type="submit" style="padding: 10px 20px; background-color: #6f42c1; color: white; border: none; cursor: pointer; font-size: 16px; margin-top: 10px;">
                        🔒 Close Bug
                    </button>
                </form>
                <p><em>Verify the fix and close the bug</em></p>
            </c:when>

            <%-- Bug is CLOSED --%>
            <c:when test="${bug.status == 'CLOSED'}">
                <div style="border: 1px solid #28a745; padding: 15px; background-color: #d4edda; color: #155724;">
                    <strong>✓ This bug has been resolved and closed.</strong>
                </div>
            </c:when>

            <%-- No actions available --%>
            <c:otherwise>
                <div style="border: 1px solid #ccc; padding: 15px; background-color: #f8f9fa;">
                    <em>No actions available for current status and role.</em>
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${sessionScope.role == 'ADMIN'}">
            <form action="/bugs/${bug.id}/delete" method="post" style="display: inline; margin-left: 20px;"
                  onsubmit="return confirm('Are you sure you want to delete this bug? This action cannot be undone.');">
                <button type="submit" style="padding: 10px 20px; background-color: #dc3545; color: white; border: none; cursor: pointer; font-size: 14px;">
                    🗑️ Delete Bug (Admin)
                </button>
            </form>
        </c:if>
    </div>

    <!-- Bug History -->
    <c:if test="${not empty history}">
        <hr style="margin: 30px 0;">
        <h3>Bug History</h3>
        <div style="border: 1px solid #007bff; padding: 20px; background-color: #f8f9fa;">
            <table border="0" cellpadding="10" style="width: 100%;">
                <c:forEach var="entry" items="${history}">
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td style="width: 180px; vertical-align: top;">
                            <strong>${entry.createdAt.toString().replace('T', ' ')}</strong>
                        </td>
                        <td style="vertical-align: top;">
                            <c:choose>
                                <c:when test="${entry.oldStatus == null}">
                                    <span style="color: blue;">● ${entry.newStatus}</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #999;">${entry.oldStatus}</span>
                                    →
                                    <span style="color: blue; font-weight: bold;">${entry.newStatus}</span>
                                </c:otherwise>
                            </c:choose>
                            <br>
                            <small style="color: #666;">by ${entry.changedBy.fullName}</small>
                            <c:if test="${not empty entry.changeNotes}">
                                <br>
                                <em style="color: #555;">${entry.changeNotes}</em>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </c:if>

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