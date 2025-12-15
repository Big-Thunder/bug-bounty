package org.shubham.bugbounty.service;

import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.BugHistory;
import org.shubham.bugbounty.model.User;
import org.shubham.bugbounty.model.enums.BugStatus;
import org.shubham.bugbounty.repositories.BugHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class BugHistoryService {

    private final BugHistoryRepository bugHistoryRepository;

    @Autowired
    public BugHistoryService(BugHistoryRepository bugHistoryRepository) {
        this.bugHistoryRepository = bugHistoryRepository;
    }

    /**
     * Create a history entry for a bug status change
     */
    public BugHistory recordStatusChange(Bug bug, BugStatus oldStatus, BugStatus newStatus,
                                         User changedBy, String changeNotes) {
        BugHistory history = new BugHistory(bug, oldStatus, newStatus, changedBy, changeNotes);
        return bugHistoryRepository.save(history);
    }

    /**
     * Get all history entries for a bug
     */
    public List<BugHistory> getBugHistory(Bug bug) {
        return bugHistoryRepository.findByBugOrderByCreatedAtAsc(bug);
    }

    /**
     * Get all history entries for a bug by ID
     */
    public List<BugHistory> getBugHistoryById(Long bugId) {
        return bugHistoryRepository.findByBugIdOrderByCreatedAtAsc(bugId);
    }

    /**
     * Get history entries in reverse chronological order (newest first)
     */
    public List<BugHistory> getBugHistoryDescending(Long bugId) {
        return bugHistoryRepository.findByBugIdOrderByCreatedAtDesc(bugId);
    }
}