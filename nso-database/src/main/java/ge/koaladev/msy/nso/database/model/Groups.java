package ge.koaladev.msy.nso.database.model;

/**
 * Created by mindia on 2/4/16.
 */
public enum Groups {

    FEDERATION("federation"),
    MANAGER("top"),
    ADMIN("admin"),
    SUPERVISOR("supervisor"),
    ACCOUNTANT("accountant"),
    CHANCELLERY("chancellery"),
    FEDERATION_MANAGER("manager");

    private String name;

    public String getName() {
        return name;
    }

    Groups(String name) {
        this.name = name;
    }
}
