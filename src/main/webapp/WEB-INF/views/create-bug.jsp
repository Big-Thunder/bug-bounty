<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Report Bug - Bug Bounty Lite</title>
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
    <h2>Report a New Bug</h2>

    <c:if test="${not empty error}">
        <div style="color: red; border: 1px solid red; padding: 10px; margin: 10px 0; background-color: #ffe6e6;">
            <strong>Error:</strong> ${error}
        </div>
    </c:if>

    <div style="border: 1px solid #007bff; padding: 20px; margin: 20px 0; background-color: #f8f9fa; max-width: 800px;">
        <form action="/bugs/create" method="post">
            <div style="margin-bottom: 15px;">
                <label for="title"><strong>Bug Title:</strong> <span style="color: red;">*</span></label><br>
                <input type="text" id="title" name="title" required
                       style="width: 100%; padding: 8px; font-size: 14px;"
                       maxlength="200"
                       placeholder="Brief summary of the bug">
                <small>Maximum 200 characters</small>
            </div>

            <div style="margin-bottom: 15px;">
                <label for="description"><strong>Description:</strong> <span style="color: red;">*</span></label><br>
                <textarea id="description" name="description" required
                          style="width: 100%; padding: 8px; font-size: 14px; min-height: 150px;"
                          placeholder="Detailed description of the bug, steps to reproduce, expected behavior, and actual behavior"></textarea>
                <small>Provide detailed information to help developers understand and fix the issue</small>
            </div>

            <div style="margin-bottom: 15px;">
                <label for="severity"><strong>Severity:</strong> <span style="color: red;">*</span></label><br>
                <select id="severity" name="severity" required style="padding: 8px; font-size: 14px;">
                    <option value="">-- Select Severity --</option>
                    <c:forEach var="sev" items="${severities}">
                        <option value="${sev}">${sev.displayName}</option>
                    </c:forEach>
                </select>
                <br>
                <small>
                    <strong>Guidelines:</strong><br>
                    • <strong>LOW:</strong> Minor issues with workarounds<br>
                    • <strong>MEDIUM:</strong> Moderate impact on functionality<br>
                    • <strong>HIGH:</strong> Significant functionality broken<br>
                    • <strong>CRITICAL:</strong> System crashes or data loss
                </small>
            </div>

            <div style="margin-bottom: 15px;">
                <label for="affectedModule"><strong>Affected Module:</strong> (Optional)</label><br>
                <input type="text" id="affectedModule" name="affectedModule"
                       style="width: 100%; padding: 8px; font-size: 14px;"
                       maxlength="100"
                       placeholder="e.g., Login Module, Payment Gateway, Search Feature">
                <small>The module or component where the bug occurs</small>
            </div>

            <div style="margin-top: 20px;">
                <button type="submit" style="padding: 10px 20px; font-size: 16px; background-color: #007bff; color: white; border: none; cursor: pointer;">
                    Submit Bug Report
                </button>
                <a href="/bugs" style="margin-left: 10px; padding: 10px 20px; display: inline-block; background-color: #6c757d; color: white; text-decoration: none;">
                    Cancel
                </a>
            </div>
        </form>
    </div>

    <div style="border: 1px solid #28a745; padding: 15px; margin: 20px 0; background-color: #e8f5e9; max-width: 800px;">
        <h3>Tips for Effective Bug Reports:</h3>
        <ul>
            <li>Use a clear, descriptive title</li>
            <li>Include steps to reproduce the issue</li>
            <li>Describe expected vs. actual behavior</li>
            <li>Mention browser/device information if relevant</li>
            <li>Add any error messages you encountered</li>
            <li>Choose appropriate severity level</li>
        </ul>
    </div>
</main>

</body>
</html>