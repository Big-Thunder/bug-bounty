package org.shubham.bugbounty.util;

public class ValidationUtil {

    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return username.length() >= 3 && username.length() <= 50 && username.matches("^[a-zA-Z0-9_]+$");
    }

    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isValidTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            return false;
        }
        return title.length() >= 5 && title.length() <= 200;
    }

    public static boolean isValidDescription(String description) {
        if (description == null || description.trim().isEmpty()) {
            return false;
        }
        return description.length() >= 10 && description.length() <= 5000;
    }

    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.trim();
    }
}