package org.shubham.bugbounty.repositories;

import org.shubham.bugbounty.model.Bug;
import org.shubham.bugbounty.model.User;
import org.shubham.bugbounty.model.enums.BugStatus;
import org.shubham.bugbounty.model.enums.Severity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BugRepository extends JpaRepository<Bug, Long> {

    List<Bug> findByStatus(BugStatus status);

    List<Bug> findBySeverity(Severity severity);

    List<Bug> findByReporter(User reporter);

    List<Bug> findByAssignedHunter(User hunter);

    List<Bug> findByReporterId(Long reporterId);

    List<Bug> findByAssignedHunterId(Long hunterId);

    List<Bug> findByStatusAndSeverity(BugStatus status, Severity severity);

    List<Bug> findAllByOrderByCreatedAtDesc();

    List<Bug> findByStatusOrderByCreatedAtDesc(BugStatus status);

    @Query("SELECT b FROM Bug b WHERE b.assignedHunter IS NULL")
    List<Bug> findUnassignedBugs();

    List<Bug> findByTitleContainingIgnoreCase(String keyword);

    long countByStatus(BugStatus status);

    long countByReporter(User reporter);

    long countByAssignedHunter(User hunter);
}