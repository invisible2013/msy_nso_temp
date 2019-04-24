/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.admin;


/**
 * @author nino
 */
public class AddAnnualReportRequest {

    private Integer id;
    private Integer year;
    private String introduction;
    private String result;
    private String governance;
    private String qualification;
    private String popularisation;
    private String fight;
    private String genderIssue;
    private String alternative;
    private String mass;
    private String conclusion;
    private Integer senderUserId;
    private int statusId;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getGovernance() {
        return governance;
    }

    public void setGovernance(String governance) {
        this.governance = governance;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getPopularisation() {
        return popularisation;
    }

    public void setPopularisation(String popularisation) {
        this.popularisation = popularisation;
    }

    public String getFight() {
        return fight;
    }

    public void setFight(String fight) {
        this.fight = fight;
    }

    public String getGenderIssue() {
        return genderIssue;
    }

    public void setGenderIssue(String genderIssue) {
        this.genderIssue = genderIssue;
    }

    public String getAlternative() {
        return alternative;
    }

    public void setAlternative(String alternative) {
        this.alternative = alternative;
    }

    public String getMass() {
        return mass;
    }

    public void setMass(String mass) {
        this.mass = mass;
    }

    public String getConclusion() {
        return conclusion;
    }

    public void setConclusion(String conclusion) {
        this.conclusion = conclusion;
    }

    public Integer getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(Integer senderUserId) {
        this.senderUserId = senderUserId;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }
}
