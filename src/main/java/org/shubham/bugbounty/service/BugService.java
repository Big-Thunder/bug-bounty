package org.shubham.bugbounty.service;

import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.User;
import org.shubham.bugbounty.model.enums.BugStatus;
import org.shubham.bugbounty.model.enums.Severity;
import org.shubham.bugbounty.repositories.BugRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BugService {

    private final BugRepository bugRepository;

    @Autowired
    public BugService(BugRepository bugRepository) {
        this.bugRepository = bugRepository;
    }

    public Bug createBug(String title, String description, Severity severity,
                         String affectedModule, User reporter) {
        Bug bug = new Bug(title, description, severity, affectedModule, reporter);
        return bugRepository.save(bug);
    }

    public Optional<Bug> findById(Long id) {
        return bugRepository.findById(id);
    }

    public List<Bug> findAllBugs() {
        return bugRepository.findAllByOrderByCreatedAtDesc();
    }

    public List<Bug> findBugsByStatus(BugStatus status) {
        return bugRepository.findByStatusOrderByCreatedAtDesc(status);
    }

    public List<Bug> findBugsBySeverity(Severity severity) {
        return bugRepository.findBySeverity(severity);
    }

    public List<Bug> findBugsByReporter(User reporter) {
        return bugRepository.findByReporter(reporter);
    }

    public List<Bug> findBugsByReporterId(Long reporterId) {
        return bugRepository.findByReporterId(reporterId);
    }

    public List<Bug> findBugsByAssignedHunter(User hunter) {
        return bugRepository.findByAssignedHunter(hunter);
    }

    public List<Bug> findBugsByAssignedHunterId(Long hunterId) {
        return bugRepository.findByAssignedHunterId(hunterId);
    }


    public List<Bug> findUnassignedBugs() {
        return bugRepository.findUnassignedBugs();
    }

    public List<Bug> searchBugsByTitle(String keyword) {
        return bugRepository.findByTitleContainingIgnoreCase(keyword);
    }

    public Bug updateBug(Bug bug) {
        return bugRepository.save(bug);
    }

    public void deleteBug(Long id) {
        bugRepository.deleteById(id);
    }

    public boolean canTransitionStatus(Bug bug, BugStatus newStatus) {
        return bug.getStatus().canTransitionTo(newStatus);
    }

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