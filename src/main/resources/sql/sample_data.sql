USE bug_bounty_db;

INSERT INTO users (username, password, email, full_name, role) VALUES
                                                                   ('admin', 'password123', 'admin@bugbounty.com', 'Admin User', 'ADMIN'),
                                                                   ('john_hunter', 'password123', 'john@bugbounty.com', 'John Doe', 'HUNTER'),
                                                                   ('jane_hunter', 'password123', 'jane@bugbounty.com', 'Jane Smith', 'HUNTER'),
                                                                   ('reporter1', 'password123', 'reporter1@bugbounty.com', 'Bob Reporter', 'REPORTER'),
                                                                   ('reporter2', 'password123', 'reporter2@bugbounty.com', 'Alice Reporter', 'REPORTER');

INSERT INTO bugs (title, description, severity, status, affected_module, reporter_id, assigned_hunter_id) VALUES
                                                                                                              ('Login button not working', 'The login button does not respond when clicked on Chrome browser', 'HIGH', 'OPEN', 'Authentication', 4, NULL),
                                                                                                              ('Incorrect calculation in report', 'Sales report showing wrong totals for Q3 2024', 'CRITICAL', 'CLAIMED', 'Reports Module', 5, 2),
                                                                                                              ('UI alignment issue on mobile', 'Header overlaps with content on mobile devices below 768px', 'LOW', 'FIXED', 'UI/Frontend', 4, 3),
                                                                                                              ('Database connection timeout', 'Application crashes when multiple users access simultaneously', 'CRITICAL', 'OPEN', 'Backend/Database', 5, NULL),
                                                                                                              ('Email notifications not sent', 'Password reset emails are not being delivered to users', 'MEDIUM', 'CLAIMED', 'Email Service', 4, 2),
                                                                                                              ('Search results pagination broken', 'Search results show only first 10 items, pagination controls missing', 'MEDIUM', 'OPEN', 'Search Module', 5, NULL),
                                                                                                              ('Export to CSV corrupts data', 'Special characters in data cause CSV export to fail', 'HIGH', 'FIXED', 'Export Module', 4, 3),
                                                                                                              ('User profile image upload fails', 'Images larger than 2MB fail to upload without error message', 'LOW', 'CLOSED', 'User Management', 5, 2);

INSERT INTO bug_history (bug_id, old_status, new_status, changed_by_user_id, change_notes) VALUES
                                                                                               (2, 'OPEN', 'CLAIMED', 2, 'Starting work on this issue'),
                                                                                               (3, 'OPEN', 'CLAIMED', 3, 'Investigating the mobile view'),
                                                                                               (3, 'CLAIMED', 'FIXED', 3, 'Fixed CSS media queries for mobile responsiveness'),
                                                                                               (5, 'OPEN', 'CLAIMED', 2, 'Looking into email service configuration'),
                                                                                               (7, 'OPEN', 'CLAIMED', 3, 'Working on CSV encoding issue'),
                                                                                               (7, 'CLAIMED', 'FIXED', 3, 'Implemented proper UTF-8 encoding for CSV export'),
                                                                                               (8, 'OPEN', 'CLAIMED', 2, 'Claimed for resolution'),
                                                                                               (8, 'CLAIMED', 'FIXED', 2, 'Added file size validation and error messaging'),
                                                                                               (8, 'FIXED', 'CLOSED', 1, 'Verified fix in production environment');