package org.shubham.bugbounty.model;

import jakarta.persistence.*;
import org.shubham.bugbounty.model.enums.BugStatus;

import java.time.LocalDateTime;

@Entity
@Table(name = "bug_history")
public class BugHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bug_id", nullable = false)
    private Bug bug;

    @Column(name = "old_status", length = 20)
    @Enumerated(EnumType.STRING)
    private BugStatus oldStatus;

    @Column(name = "new_status", nullable = false, length = 20)
    @Enumerated(EnumType.STRING)
    private BugStatus newStatus;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "changed_by_user_id", nullable = false)
    private User changedBy;

    @Column(name = "change_notes", columnDefinition = "TEXT")
    private String changeNotes;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // Constructors
    public BugHistory() {
    }

    public BugHistory(Bug bug, BugStatus oldStatus, BugStatus newStatus, User changedBy, String changeNotes) {
        this.bug = bug;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.changedBy = changedBy;
        this.changeNotes = changeNotes;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Bug getBug() {
        return bug;
    }

    public void setBug(Bug bug) {
        this.bug = bug;
    }

    public BugStatus getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(BugStatus oldStatus) {
        this.oldStatus = oldStatus;
    }

    public BugStatus getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(BugStatus newStatus) {
        this.newStatus = newStatus;
    }

    public User getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(User changedBy) {
        this.changedBy = changedBy;
    }

    public String getChangeNotes() {
        return changeNotes;
    }

    public void setChangeNotes(String changeNotes) {
        this.changeNotes = changeNotes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "BugHistory{" +
                "id=" + id +
                ", bugId=" + (bug != null ? bug.getId() : "null") +
                ", oldStatus=" + oldStatus +
                ", newStatus=" + newStatus +
                ", changedBy=" + (changedBy != null ? changedBy.getUsername() : "null") +
                ", createdAt=" + createdAt +
                '}';
    }
}