package ge.koaladev.msy.nso.core.dto.admin;

/**
 * Created by ninolomineishvili on 4/19/19.
 */
public class GetResultRequest {


    private Integer id;
    private Integer federationId;
    private Integer limit;
    private Integer offset;
    private Integer year;
    private Integer userId;
    private String fullText;
    private boolean isFederation;
    private boolean isManager;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getLimit() {
        return limit;
    }

    public void setLimit(Integer limit) {
        this.limit = limit;
    }

    public Integer getOffset() {
        return offset;
    }

    public void setOffset(Integer offset) {
        this.offset = offset;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getFullText() {
        return fullText;
    }

    public void setFullText(String fullText) {
        this.fullText = fullText;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public boolean isFederation() {
        return isFederation;
    }

    public void setFederation(boolean federation) {
        isFederation = federation;
    }

    public boolean isManager() {
        return isManager;
    }

    public void setManager(boolean manager) {
        isManager = manager;
    }

    public Integer getFederationId() {
        return federationId;
    }

    public void setFederationId(Integer federationId) {
        this.federationId = federationId;
    }
}
