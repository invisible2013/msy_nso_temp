/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.admin;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ge.koaladev.msy.nso.core.dto.objects.PersonDTO;
import ge.koaladev.msy.nso.core.misc.JsonDateDeSerializeSupport;

import java.util.Date;
import java.util.List;

/**
 * @author mindia
 */
public class AddCalendarRequest {

    private Integer id;
    private String name;
    private String location;
    private String participant;
    private String note;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date eventDate;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date endDate;
    private int senderUserId;
    private int statusId;
    private int calendarTypeId;
    private Double first;
    private Double second;
    private Double third;
    private Double fourth;
    private List<PersonDTO> persons;
    private List<Integer> personsIds;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public int getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(int senderUserId) {
        this.senderUserId = senderUserId;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public int getCalendarTypeId() {
        return calendarTypeId;
    }

    public void setCalendarTypeId(int calendarTypeId) {
        this.calendarTypeId = calendarTypeId;
    }

    public Double getFirst() {
        return first;
    }

    public void setFirst(Double first) {
        this.first = first;
    }

    public Double getSecond() {
        return second;
    }

    public void setSecond(Double second) {
        this.second = second;
    }

    public Double getThird() {
        return third;
    }

    public void setThird(Double third) {
        this.third = third;
    }

    public Double getFourth() {
        return fourth;
    }

    public void setFourth(Double fourth) {
        this.fourth = fourth;
    }

    public List<PersonDTO> getPersons() {
        return persons;
    }

    public void setPersons(List<PersonDTO> persons) {
        this.persons = persons;
    }

    public List<Integer> getPersonsIds() {
        return personsIds;
    }

    public void setPersonsIds(List<Integer> personsIds) {
        this.personsIds = personsIds;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getParticipant() {
        return participant;
    }

    public void setParticipant(String participant) {
        this.participant = participant;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
