package org.shubham.bugbounty.repositories;

import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.BugHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BugHistoryRepository extends JpaRepository<BugHistory, Long> {

    List<BugHistory> findByBugOrderByCreatedAtAsc(Bug bug);

    List<BugHistory> findByBugIdOrderByCreatedAtAsc(Long bugId);

    List<BugHistory> findByBugIdOrderByCreatedAtDesc(Long bugId);
}