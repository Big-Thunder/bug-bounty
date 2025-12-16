package org.shubham.bugbounty.service;

import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.User;
import org.shubham.bugbounty.model.enums.BugStatus;
import org.shubham.bugbounty.model.enums.Role;
import org.shubham.bugbounty.model.enums.Severity;
import org.shubham.bugbounty.repositories.BugRepository;
import org.shubham.bugbounty.util.ValidationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BugService {

    private final BugRepository bugRepository;
    private final BugHistoryService bugHistoryService;

    @Autowired
    public BugService(BugRepository bugRepository, BugHistoryService bugHistoryService) {
        this.bugRepository = bugRepository;
        this.bugHistoryService = bugHistoryService;
    }

    public Bug createBug(String title, String description, Severity severity,
                         String affectedModule, User reporter) {
        title = ValidationUtil.sanitizeInput(title);
        description = ValidationUtil.sanitizeInput(description);
        affectedModule = ValidationUtil.sanitizeInput(affectedModule);

        if (!ValidationUtil.isValidTitle(title)) {
            throw new IllegalArgumentException("Title must be between 5 and 200 characters");
        }

        if (!ValidationUtil.isValidDescription(description)) {
            throw new IllegalArgumentException("Description must be between 10 and 5000 characters");
        }

        if (severity == null) {
            throw new IllegalArgumentException("Severity is required");
        }

        if (reporter == null) {
            throw new IllegalArgumentException("Reporter is required");
        }

        Bug bug = new Bug(title, description, severity, affectedModule, reporter);
        Bug savedBug = bugRepository.save(bug);

        bugHistoryService.recordStatusChange(savedBug, null, BugStatus.OPEN, reporter, "Bug reported");

        return savedBug;
    }

    /**
     * Claim a bug (Hunter only)
     */
    public Bug claimBug(Long bugId, User hunter) {
        if (hunter.getRole() != Role.HUNTER) {
            throw new IllegalStateException("Only hunters can claim bugs");
        }

        Optional<Bug> bugOpt = bugRepository.findById(bugId);
        if (bugOpt.isEmpty()) {
            throw new IllegalArgumentException("Bug not found");
        }

        Bug bug = bugOpt.get();

        // Check if bug is in OPEN status
        if (bug.getStatus() != BugStatus.OPEN) {
            throw new IllegalStateException("Bug must be in OPEN status to be claimed");
        }

        // Check if already assigned
        if (bug.getAssignedHunter() != null) {
            throw new IllegalStateException("Bug is already claimed by another hunter");
        }

        // Claim the bug
        BugStatus oldStatus = bug.getStatus();
        bug.setStatus(BugStatus.CLAIMED);
        bug.setAssignedHunter(hunter);
        Bug updatedBug = bugRepository.save(bug);

        // Record in history
        bugHistoryService.recordStatusChange(updatedBug, oldStatus, BugStatus.CLAIMED,
                hunter, "Bug claimed for resolution");

        return updatedBug;
    }

    public Bug markAsFixed(Long bugId, User hunter, String resolutionNotes) {
        if (hunter.getRole() != Role.HUNTER) {
            throw new IllegalStateException("Only hunters can mark bugs as fixed");
        }

        resolutionNotes = ValidationUtil.sanitizeInput(resolutionNotes);

        if (resolutionNotes == null || resolutionNotes.length() < 10) {
            throw new IllegalArgumentException("Resolution notes must be at least 10 characters");
        }

        if (resolutionNotes.length() > 2000) {
            throw new IllegalArgumentException("Resolution notes cannot exceed 2000 characters");
        }

        Optional<Bug> bugOpt = bugRepository.findById(bugId);
        if (bugOpt.isEmpty()) {
            throw new IllegalArgumentException("Bug not found");
        }

        Bug bug = bugOpt.get();

        if (bug.getStatus() != BugStatus.CLAIMED) {
            throw new IllegalStateException("Bug must be in CLAIMED status to be marked as fixed");
        }

        if (bug.getAssignedHunter() == null || !bug.getAssignedHunter().getId().equals(hunter.getId())) {
            throw new IllegalStateException("Bug can only be marked as fixed by the assigned hunter");
        }

        BugStatus oldStatus = bug.getStatus();
        bug.setStatus(BugStatus.FIXED);
        bug.setResolutionNotes(resolutionNotes);
        Bug updatedBug = bugRepository.save(bug);

        bugHistoryService.recordStatusChange(updatedBug, oldStatus, BugStatus.FIXED,
                hunter, resolutionNotes);

        return updatedBug;
    }

    public Bug closeBug(Long bugId, User admin, String verificationNotes) {
        if (admin.getRole() != Role.ADMIN) {
            throw new IllegalStateException("Only admins can close bugs");
        }

        verificationNotes = ValidationUtil.sanitizeInput(verificationNotes);

        if (verificationNotes != null && verificationNotes.length() > 2000) {
            throw new IllegalArgumentException("Verification notes cannot exceed 2000 characters");
        }

        Optional<Bug> bugOpt = bugRepository.findById(bugId);
        if (bugOpt.isEmpty()) {
            throw new IllegalArgumentException("Bug not found");
        }

        Bug bug = bugOpt.get();

        if (bug.getStatus() != BugStatus.FIXED) {
            throw new IllegalStateException("Bug must be in FIXED status to be closed");
        }

        BugStatus oldStatus = bug.getStatus();
        bug.setStatus(BugStatus.CLOSED);

        if (verificationNotes != null && !verificationNotes.trim().isEmpty()) {
            String currentNotes = bug.getResolutionNotes() != null ? bug.getResolutionNotes() : "";
            bug.setResolutionNotes(currentNotes + "\n\n--- Admin Verification ---\n" + verificationNotes);
        }

        Bug updatedBug = bugRepository.save(bug);

        bugHistoryService.recordStatusChange(updatedBug, oldStatus, BugStatus.CLOSED,
                admin, verificationNotes != null ? verificationNotes : "Bug verified and closed");

        return updatedBug;
    }

    /**
     * Find bug by ID
     */
    public Optional<Bug> findById(Long id) {
        return bugRepository.findById(id);
    }

    /**
     * Get all bugs
     */
    public List<Bug> findAllBugs() {
        return bugRepository.findAllByOrderByCreatedAtDesc();
    }

    /**
     * Find bugs by status
     */
    public List<Bug> findBugsByStatus(BugStatus status) {
        return bugRepository.findByStatusOrderByCreatedAtDesc(status);
    }

    /**
     * Find bugs by severity
     */
    public List<Bug> findBugsBySeverity(Severity severity) {
        return bugRepository.findBySeverity(severity);
    }

    /**
     * Find bugs by reporter
     */
    public List<Bug> findBugsByReporter(User reporter) {
        return bugRepository.findByReporter(reporter);
    }

    /**
     * Find bugs by reporter ID
     */
    public List<Bug> findBugsByReporterId(Long reporterId) {
        return bugRepository.findByReporterId(reporterId);
    }

    /**
     * Find bugs assigned to hunter
     */
    public List<Bug> findBugsByAssignedHunter(User hunter) {
        return bugRepository.findByAssignedHunter(hunter);
    }

    /**
     * Find bugs assigned to hunter by ID
     */
    public List<Bug> findBugsByAssignedHunterId(Long hunterId) {
        return bugRepository.findByAssignedHunterId(hunterId);
    }

    /**
     * Find unassigned bugs (status OPEN with no hunter)
     */
    public List<Bug> findUnassignedBugs() {
        return bugRepository.findUnassignedBugs();
    }

    /**
     * Search bugs by title
     */
    public List<Bug> searchBugsByTitle(String keyword) {
        return bugRepository.findByTitleContainingIgnoreCase(keyword);
    }

    /**
     * Update bug
     */
    public Bug updateBug(Bug bug) {
        return bugRepository.save(bug);
    }

    /**
     * Delete bug
     */
    public void deleteBug(Long id) {
        bugRepository.deleteById(id);
    }

    /**
     * Validate status transition
     */
    public boolean canTransitionStatus(Bug bug, BugStatus newStatus) {
        return bug.getStatus().canTransitionTo(newStatus);
    }

    /**
     * Get bug statistics
     */
    public long countBugsByStatus(BugStatus status) {
        return bugRepository.countByStatus(status);
    }

    public long countBugsByReporter(User reporter) {
        return bugRepository.countByReporter(reporter);
    }

    public long countBugsByAssignedHunter(User hunter) {
        return bugRepository.countByAssignedHunter(hunter);
    }
}