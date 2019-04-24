package ge.koaladev.msy.nso.core.dto.admin.event;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ge.koaladev.msy.nso.core.misc.JsonDateDeSerializeSupport;

import java.util.Date;

/**
 * Created by mindia on 3/26/17.
 */
public class GetEventsRequest {

    //not client side
    private Integer senderUserId;
    //not client side
    private Integer supervisorId;
    //not client side
    private Integer accountantId;
    //not client side
    private Integer chancelleryId;
    //not client side
    private Integer desicionId;
    //not client side
    private boolean isAdmin;

    private Integer federationId;
    private Integer statusId;
    private Integer limit;
    private Integer offset;
    private Integer year;

    private String fullText;

    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date registeredDate;

    public Integer getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(Integer senderUserId) {
        this.senderUserId = senderUserId;
    }

    public Integer getSupervisorId() {
        return supervisorId;
    }

    public void setSupervisorId(Integer supervisorId) {
        this.supervisorId = supervisorId;
    }

    public Integer getAccountantId() {
        return accountantId;
    }

    public void setAccountantId(Integer accountantId) {
        this.accountantId = accountantId;
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

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    public Integer getDesicionId() {
        return desicionId;
    }

    public void setDesicionId(Integer desicionId) {
        this.desicionId = desicionId;
    }

    public String getFullText() {
        return fullText;
    }

    public void setFullText(String fullText) {
        this.fullText = fullText;
    }

    public Integer getChancelleryId() {
        return chancelleryId;
    }

    public void setChancelleryId(Integer chancelleryId) {
        this.chancelleryId = chancelleryId;
    }

    public Date getRegisteredDate() {
        return registeredDate;
    }

    public void setRegisteredDate(Date registeredDate) {
        this.registeredDate = registeredDate;
    }

    public Integer getFederationId() {
        return federationId;
    }

    public void setFederationId(Integer federationId) {
        this.federationId = federationId;
    }
}
