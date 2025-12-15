package org.shubham.bugbounty.controller;

import jakarta.servlet.http.HttpSession;
import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.User;
import org.shubham.bugbounty.model.enums.BugStatus;
import org.shubham.bugbounty.model.enums.Role;
import org.shubham.bugbounty.model.enums.Severity;
import org.shubham.bugbounty.service.BugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/bugs")
public class BugController {

    private final BugService bugService;

    @Autowired
    public BugController(BugService bugService) {
        this.bugService = bugService;
    }

    @GetMapping
    public String listBugs(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String assignedTo,
            @RequestParam(required = false) String reportedBy,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Bug> bugs;

        // Apply filters
        if (status != null && !status.isEmpty()) {
            BugStatus bugStatus = BugStatus.valueOf(status.toUpperCase());
            bugs = bugService.findBugsByStatus(bugStatus);
        } else if ("me".equals(assignedTo)) {
            bugs = bugService.findBugsByAssignedHunter(user);
        } else if ("me".equals(reportedBy)) {
            bugs = bugService.findBugsByReporter(user);
        } else {
            bugs = bugService.findAllBugs();
        }

        model.addAttribute("bugs", bugs);
        model.addAttribute("user", user);
        model.addAttribute("selectedStatus", status);

        return "bug-list";
    }

    @GetMapping("/{id}")
    public String viewBug(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Optional<Bug> bugOpt = bugService.findById(id);
        if (bugOpt.isEmpty()) {
            model.addAttribute("error", "Bug not found");
            return "redirect:/bugs";
        }

        Bug bug = bugOpt.get();
        model.addAttribute("bug", bug);
        model.addAttribute("user", user);

        return "bug-detail";
    }

    @GetMapping("/create")
    public String showCreateBugForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // Only reporters can create bugs
        if (user.getRole() != Role.REPORTER) {
            model.addAttribute("error", "Only reporters can create bugs");
            return "redirect:/bugs";
        }

        model.addAttribute("severities", Severity.values());
        return "create-bug";
    }

    @PostMapping("/create")
    public String createBug(
            @RequestParam String title,
            @RequestParam String description,
            @RequestParam String severity,
            @RequestParam(required = false) String affectedModule,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // Only reporters can create bugs
        if (user.getRole() != Role.REPORTER) {
            model.addAttribute("error", "Only reporters can create bugs");
            return "redirect:/bugs";
        }

        // Validate inputs
        if (title == null || title.trim().isEmpty()) {
            model.addAttribute("error", "Title is required");
            model.addAttribute("severities", Severity.values());
            return "create-bug";
        }

        if (description == null || description.trim().isEmpty()) {
            model.addAttribute("error", "Description is required");
            model.addAttribute("severities", Severity.values());
            return "create-bug";
        }

        try {
            Severity bugSeverity = Severity.valueOf(severity.toUpperCase());
            Bug bug = bugService.createBug(title, description, bugSeverity, affectedModule, user);

            return "redirect:/bugs/" + bug.getId();

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", "Invalid severity level");
            model.addAttribute("severities", Severity.values());
            return "create-bug";
        }
    }

    // Delete bug (Admin only, we'll implement authorization later)
    @PostMapping("/{id}/delete")
    public String deleteBug(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // Only admins can delete bugs
        if (user.getRole() != Role.ADMIN) {
            model.addAttribute("error", "Only admins can delete bugs");
            return "redirect:/bugs";
        }

        bugService.deleteBug(id);
        return "redirect:/bugs";
    }
}