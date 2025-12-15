package org.shubham.bugbounty.model.enums;

public enum BugStatus {
    OPEN("Open"),
    CLAIMED("Claimed"),
    FIXED("Fixed"),
    CLOSED("Closed");

    private final String displayName;

    BugStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }


    //Check if status can transition to next status

    public boolean canTransitionTo(BugStatus newStatus) {
        switch (this) {
            case OPEN:
                return newStatus == CLAIMED;
            case CLAIMED:
                return newStatus == FIXED;
            case FIXED:
                return newStatus == CLOSED;
            case CLOSED:
                return false; // Cannot transition from CLOSED
            default:
                return false;
        }
    }
}