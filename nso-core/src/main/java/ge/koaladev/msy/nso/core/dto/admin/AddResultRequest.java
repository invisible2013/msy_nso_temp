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
public class AddResultRequest {

    private Integer id;
    private String note;
    private String discipline;
    private String score;
    @JsonDeserialize(using = JsonDateDeSerializeSupport.class)
    private Date createDate;
    private int userId;
    private int sportsmanId;
    private int championshipId;
    private int awardId;
    private boolean isTeam;
    private String category;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getDiscipline() {
        return discipline;
    }

    public void setDiscipline(String discipline) {
        this.discipline = discipline;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getSportsmanId() {
        return sportsmanId;
    }

    public void setSportsmanId(int sportsmanId) {
        this.sportsmanId = sportsmanId;
    }

    public int getChampionshipId() {
        return championshipId;
    }

    public void setChampionshipId(int championshipId) {
        this.championshipId = championshipId;
    }

    public boolean isTeam() {
        return isTeam;
    }

    public void setTeam(boolean team) {
        isTeam = team;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getAwardId() {
        return awardId;
    }

    public void setAwardId(int awardId) {
        this.awardId = awardId;
    }
}
