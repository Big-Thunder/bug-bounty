# Bug Bounty Lite

## Overview
Bug Bounty Lite is a lightweight, internal bug tracking system inspired by real-world bug bounty and issue management platforms. It is designed for small teams to report, claim, fix, and verify bugs while following a realistic and structured workflow.

The project demonstrates clean Java web application architecture using **Spring Boot**, **Spring MVC**, **Hibernate**, **JSP**, and **MySQL**.

---

## Features

- Session-based user authentication
- Role-based access (Reporter, Hunter, Admin)
- Bug reporting with severity and module details
- Realistic bug lifecycle:

```
OPEN → CLAIMED → FIXED → CLOSED
```

- Bug claiming by developers
- Fix verification before closure
- Complete status change history for each bug

---

## Tech Stack

- **Backend**: Java, Spring Boot, Spring MVC
- **View Layer**: JSP, JSTL, Bootstrap (basic)
- **Persistence**: Hibernate ORM (JPA)
- **Database**: MySQL
- **Build Tool**: Maven
- **Server**: Embedded Tomcat

---

## Architecture

The application follows a layered MVC architecture:

- Controller layer for request handling
- Service layer for business logic and workflow rules
- Repository layer for database access
- MySQL as the relational data store

---

## Bug Workflow

- Bugs are reported with status **OPEN**
- Developers claim bugs (**CLAIMED**)
- Fixes are marked as **FIXED** by the assigned developer
- Admins verify and close bugs (**CLOSED**)

Each transition is validated and recorded for traceability.

---

## Future Scope

- Bug comments and attachments
- Reopen bug functionality
- Advanced filtering and pagination
- Spring Security integration
- REST API support and frontend separation

---

## Summary

Bug Bounty Lite is a concise yet industry-aligned Java web application that models real development workflows while keeping the implementation practical and maintainable. It is well-suited for demonstrating backend and full-stack Java skills in internship or entry-level roles.

