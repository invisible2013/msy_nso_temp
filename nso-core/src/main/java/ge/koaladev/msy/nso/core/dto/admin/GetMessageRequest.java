package ge.koaladev.msy.nso.core.dto.admin;

/**
 * Created by ninolomineishvili on 4/16/18.
 */
public class GetMessageRequest {


    private Integer statusId;
    private Integer messageId;
    private Integer limit;
    private Integer offset;
    private Integer year;
    private Integer userId;
    private String fullText;
    private boolean isFedaration;


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

    public Integer getMessageId() {
        return messageId;
    }

    public void setMessageId(Integer messageId) {
        this.messageId = messageId;
    }

    public boolean isFedaration() {
        return isFedaration;
    }

    public void setFedaration(boolean fedaration) {
        isFedaration = fedaration;
    }
}
