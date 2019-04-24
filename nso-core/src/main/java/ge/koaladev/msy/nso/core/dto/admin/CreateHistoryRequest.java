/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.admin;

/**
 * @author mindia
 */
public class CreateHistoryRequest {

    private Integer eventId;
    private Integer senderUserId;
    private Integer recepientUserId;
    private Integer statusId;
    private Integer desicionId;
    private Integer supervisorId;
    private Integer dispatcherId;
    private Integer accountantId;
    private Integer iteration;
    private Double amount;
    private String idNumber;
    private String registrationNumber;
    private String note;

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public Integer getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(Integer senderUserId) {
        this.senderUserId = senderUserId;
    }

    public Integer getRecepientUserId() {
        return recepientUserId;
    }

    public void setRecepientUserId(Integer recepientUserId) {
        this.recepientUserId = recepientUserId;
    }

    public Integer getStatusId() {
        return statusId;
    }

    public void setStatusId(Integer statusId) {
        this.statusId = statusId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Integer getDesicionId() {
        return desicionId;
    }

    public void setDesicionId(Integer desicionId) {
        this.desicionId = desicionId;
    }

    public Integer getSupervisorId() {
        return supervisorId;
    }

    public void setSupervisorId(Integer supervisorId) {
        this.supervisorId = supervisorId;
    }

    public Integer getDispatcherId() {
        return dispatcherId;
    }

    public void setDispatcherId(Integer dispatcherId) {
        this.dispatcherId = dispatcherId;
    }

    public Integer getAccountantId() {
        return accountantId;
    }

    public void setAccountantId(Integer accountantId) {
        this.accountantId = accountantId;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public Integer getIteration() {
        return iteration;
    }

    public void setIteration(Integer iteration) {
        this.iteration = iteration;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }
}
