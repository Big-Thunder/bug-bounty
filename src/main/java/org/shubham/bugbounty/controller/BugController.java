package org.shubham.bugbounty.controller;

import jakarta.servlet.http.HttpSession;
import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.BugHistory;
import org.shubham.bugbounty.model.User;
import org.shubham.bugbounty.model.enums.BugStatus;
import org.shubham.bugbounty.model.enums.Role;
import org.shubham.bugbounty.model.enums.Severity;
import org.shubham.bugbounty.service.BugHistoryService;
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
    private final BugHistoryService bugHistoryService;

    @Autowired
    public BugController(BugService bugService, BugHistoryService bugHistoryService) {
        this.bugService = bugService;
        this.bugHistoryService = bugHistoryService;
    }

    /**
     * List all bugs with optional filtering
     */
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

    /**
     * Show bug details
     */
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
        List<BugHistory> history = bugHistoryService.getBugHistoryById(id);

        model.addAttribute("bug", bug);
        model.addAttribute("history", history);
        model.addAttribute("user", user);

        return "bug-detail";
    }

    @GetMapping("/create")
    public String showCreateBugForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (user.getRole() != Role.REPORTER && user.getRole() != Role.ADMIN) {
            model.addAttribute("error", "Only reporters and admins can create bugs");
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

        if (user.getRole() != Role.REPORTER && user.getRole() != Role.ADMIN) {
            model.addAttribute("error", "Only reporters and admins can create bugs");
            return "redirect:/bugs";
        }

        try {
            Severity bugSeverity = Severity.valueOf(severity.toUpperCase());
            Bug bug = bugService.createBug(title, description, bugSeverity, affectedModule, user);

            return "redirect:/bugs/" + bug.getId();

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("severities", Severity.values());
            return "create-bug";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to create bug. Please try again.");
            model.addAttribute("severities", Severity.values());
            return "create-bug";
        }
    }

    @PostMapping("/{id}/claim")
    public String claimBug(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            bugService.claimBug(id, user);
            return "redirect:/bugs/" + id;
        } catch (IllegalStateException | IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
            return "redirect:/bugs/" + id;
        } catch (Exception e) {
            session.setAttribute("error", "Failed to claim bug. Please try again.");
            return "redirect:/bugs/" + id;
        }
    }

    @PostMapping("/{id}/fix")
    public String markAsFixed(
            @PathVariable Long id,
            @RequestParam String resolutionNotes,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            bugService.markAsFixed(id, user, resolutionNotes);
            return "redirect:/bugs/" + id;
        } catch (IllegalStateException | IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
            return "redirect:/bugs/" + id;
        } catch (Exception e) {
            session.setAttribute("error", "Failed to mark bug as fixed. Please try again.");
            return "redirect:/bugs/" + id;
        }
    }

    @PostMapping("/{id}/close")
    public String closeBug(
            @PathVariable Long id,
            @RequestParam(required = false) String verificationNotes,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            bugService.closeBug(id, user, verificationNotes);
            return "redirect:/bugs/" + id;
        } catch (IllegalStateException | IllegalArgumentException e) {
            session.setAttribute("error", e.getMessage());
            return "redirect:/bugs/" + id;
        } catch (Exception e) {
            session.setAttribute("error", "Failed to close bug. Please try again.");
            return "redirect:/bugs/" + id;
        }
    }

    /**
     * Delete bug (Admin only)
     */
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