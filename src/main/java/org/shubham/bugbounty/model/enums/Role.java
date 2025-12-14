package org.shubham.bugbounty.model.enums;

public enum Role {
    REPORTER("Reporter"),
    HUNTER("Hunter"),
    ADMIN("Admin");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}