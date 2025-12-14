package org.shubham.bugbounty.controller;

import jakarta.servlet.http.HttpSession;
import org.shubham.bugbounty.model.User;
import org.shubham.bugbounty.model.enums.Role;
import org.shubham.bugbounty.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@Controller
public class AuthController {

    private final UserService userService;

    @Autowired
    public AuthController(UserService userService) {
        this.userService = userService;
    }

    /**
     * Show login page
     */
    @GetMapping("/login")
    public String showLoginPage(HttpSession session) {
        // If already logged in, redirect to home
        if (session.getAttribute("user") != null) {
            return "redirect:/home";
        }
        return "login";
    }

    /**
     * Process login
     */
    @PostMapping("/login")
    public String processLogin(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        Optional<User> userOpt = userService.authenticate(username, password);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Store user in session
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            return "redirect:/home";
        } else {
            model.addAttribute("error", "Invalid username or password");
            return "login";
        }
    }

    /**
     * Show registration page
     */
    @GetMapping("/register")
    public String showRegisterPage(HttpSession session) {
        // If already logged in, redirect to home
        if (session.getAttribute("user") != null) {
            return "redirect:/home";
        }
        return "register";
    }

    /**
     * Process registration
     */
    @PostMapping("/register")
    public String processRegistration(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String email,
            @RequestParam String fullName,
            @RequestParam String role,
            Model model) {

        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match");
            return "register";
        }

        // Validate password length
        if (password.length() < 6) {
            model.addAttribute("error", "Password must be at least 6 characters");
            return "register";
        }

        try {
            Role userRole = Role.valueOf(role.toUpperCase());
            User user = userService.registerUser(username, password, email, fullName, userRole);

            model.addAttribute("success", "Registration successful! Please login.");
            return "login";

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
    }

    /**
     * Logout
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}