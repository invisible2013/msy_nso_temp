/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.admin;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ge.koaladev.msy.nso.core.misc.JsonDateDeSerializeSupport;

import java.util.Date;

/**
 * @author mindia
 */
public class AddEventRequest {

    private int id;
    private String eventName;
    private String eventDescription;
    private String purpose;
    private String expectedResult;
    private String letterNumber;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date startDate;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date endDate;
    private String responsiblePerson;
    private String responsiblePersonPosition;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date reportDeliveryDate;
    private Double budget;
    private int senderUserId;
    private int lastStatusId;
    private int eventTypeId;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date lastStatusDate;
    private int applicationTypeId;
    private int iteration;
    private int lastUserId;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getEventDescription() {
        return eventDescription;
    }

    public void setEventDescription(String eventDescription) {
        this.eventDescription = eventDescription;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getExpectedResult() {
        return expectedResult;
    }

    public void setExpectedResult(String expectedResult) {
        this.expectedResult = expectedResult;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getResponsiblePerson() {
        return responsiblePerson;
    }

    public void setResponsiblePerson(String responsiblePerson) {
        this.responsiblePerson = responsiblePerson;
    }

    public String getResponsiblePersonPosition() {
        return responsiblePersonPosition;
    }

    public void setResponsiblePersonPosition(String responsiblePersonPosition) {
        this.responsiblePersonPosition = responsiblePersonPosition;
    }

    public Date getReportDeliveryDate() {
        return reportDeliveryDate;
    }

    public void setReportDeliveryDate(Date reportDeliveryDate) {
        this.reportDeliveryDate = reportDeliveryDate;
    }

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
    }

    public int getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(int senderUserId) {
        this.senderUserId = senderUserId;
    }

    public int getLastStatusId() {
        return lastStatusId;
    }

    public void setLastStatusId(int lastStatusId) {
        this.lastStatusId = lastStatusId;
    }

    public Date getLastStatusDate() {
        return lastStatusDate;
    }

    public void setLastStatusDate(Date lastStatusDate) {
        this.lastStatusDate = lastStatusDate;
    }

    public int getEventTypeId() {
        return eventTypeId;
    }

    public void setEventTypeId(int eventTypeId) {
        this.eventTypeId = eventTypeId;
    }

    public int getApplicationTypeId() {
        return applicationTypeId;
    }

    public void setApplicationTypeId(int applicationTypeId) {
        this.applicationTypeId = applicationTypeId;
    }

    public int getIteration() {
        return iteration;
    }

    public void setIteration(int iteration) {
        this.iteration = iteration;
    }

    public int getLastUserId() {
        return lastUserId;
    }

    public void setLastUserId(int lastUserId) {
        this.lastUserId = lastUserId;
    }

    public String getLetterNumber() {
        return letterNumber;
    }

    public void setLetterNumber(String letterNumber) {
        this.letterNumber = letterNumber;
    }
}
