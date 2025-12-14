CREATE DATABASE IF NOT EXISTS bug_bounty_db;
USE bug_bounty_db;

DROP TABLE IF EXISTS bug_history;
DROP TABLE IF EXISTS bugs;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       full_name VARCHAR(100) NOT NULL,
                       role VARCHAR(20) NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       INDEX idx_username (username),
                       INDEX idx_email (email),
                       INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE bugs (
                      id BIGINT PRIMARY KEY AUTO_INCREMENT,
                      title VARCHAR(200) NOT NULL,
                      description TEXT NOT NULL,
                      severity VARCHAR(20) NOT NULL,
                      status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
                      affected_module VARCHAR(100),
                      resolution_notes TEXT,
                      reporter_id BIGINT NOT NULL,
                      assigned_hunter_id BIGINT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                      FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE,
                      FOREIGN KEY (assigned_hunter_id) REFERENCES users(id) ON DELETE SET NULL,
                      INDEX idx_status (status),
                      INDEX idx_severity (severity),
                      INDEX idx_reporter (reporter_id),
                      INDEX idx_hunter (assigned_hunter_id),
                      INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE bug_history (
                             id BIGINT PRIMARY KEY AUTO_INCREMENT,
                             bug_id BIGINT NOT NULL,
                             old_status VARCHAR(20),
                             new_status VARCHAR(20) NOT NULL,
                             changed_by_user_id BIGINT NOT NULL,
                             change_notes TEXT,
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (bug_id) REFERENCES bugs(id) ON DELETE CASCADE,
                             FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE CASCADE,
                             INDEX idx_bug_id (bug_id),
                             INDEX idx_changed_by (changed_by_user_id),
                             INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;