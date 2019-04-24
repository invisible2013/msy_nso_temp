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
 * @author nino
 */
public class AddCompetitionRequest {

    private Integer id;
    private String name;
    private String location;
    private String category;
    private String groupQuantity;
    private String professional;
    private String discipline;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date competitionDate;
    private int senderUserId;
    private int federationId;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getGroupQuantity() {
        return groupQuantity;
    }

    public void setGroupQuantity(String groupQuantity) {
        this.groupQuantity = groupQuantity;
    }

    public String getProfessional() {
        return professional;
    }

    public void setProfessional(String professional) {
        this.professional = professional;
    }

    public Date getCompetitionDate() {
        return competitionDate;
    }

    public void setCompetitionDate(Date competitionDate) {
        this.competitionDate = competitionDate;
    }

    public int getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(int senderUserId) {
        this.senderUserId = senderUserId;
    }

    public String getDiscipline() {
        return discipline;
    }

    public void setDiscipline(String discipline) {
        this.discipline = discipline;
    }

    public int getFederationId() {
        return federationId;
    }

    public void setFederationId(int federationId) {
        this.federationId = federationId;
    }
}