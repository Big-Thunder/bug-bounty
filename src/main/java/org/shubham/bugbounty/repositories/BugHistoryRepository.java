package org.shubham.bugbounty.repositories;

import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.BugHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BugHistoryRepository extends JpaRepository<BugHistory, Long> {

    // Find all history entries for a specific bug, ordered by created date
    List<BugHistory> findByBugOrderByCreatedAtAsc(Bug bug);

    // Find all history entries for a bug by ID
    List<BugHistory> findByBugIdOrderByCreatedAtAsc(Long bugId);

    // Find history entries by bug ID in descending order (newest first)
    List<BugHistory> findByBugIdOrderByCreatedAtDesc(Long bugId);
}