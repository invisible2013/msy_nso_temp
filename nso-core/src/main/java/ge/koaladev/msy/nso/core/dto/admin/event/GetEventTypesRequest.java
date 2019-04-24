package ge.koaladev.msy.nso.core.dto.admin.event;

/**
 * Created by mindia on 3/26/17.
 */
public class GetEventTypesRequest {

    private int applicationTypeId;

    public int getApplicationTypeId() {
        return applicationTypeId;
    }

    public void setApplicationTypeId(int applicationTypeId) {
        this.applicationTypeId = applicationTypeId;
    }
}
