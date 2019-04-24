package ge.koaladev.msy.nso.core.dto.admin;

/**
 * Created by ninolomineishvili on 4/16/18.
 */
public class GetCalendarRequest {


    private Integer id;
    private Integer statusId;
    private Integer calendarId;
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

    public Integer getStatusId() {
        return statusId;
    }

    public void setStatusId(Integer statusId) {
        this.statusId = statusId;
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

    public Integer getCalendarId() {
        return calendarId;
    }

    public void setCalendarId(Integer calendarId) {
        this.calendarId = calendarId;
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
