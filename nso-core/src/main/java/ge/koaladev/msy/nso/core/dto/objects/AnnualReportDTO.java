package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author nino
 */
public class AnnualReportDTO {

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
    private String note;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;
    private List<AnnualReportDocumentDTO> documents;
    private UserDTO senderUser;
    private AnnualReportStatus annualReportStatus;

    public static Integer STATUS_NEW = 1;
    public static Integer STATUS_BLOCKED = 2;
    public static Integer STATUS_SENT = 3;
    public static Integer STATUS_CORRECTED = 4;



    public static AnnualReportDTO parse(AnnualReport item) {

        AnnualReportDTO requestDTO = new AnnualReportDTO();
        requestDTO.setId(item.getId());
        requestDTO.setYear(item.getYear());
        requestDTO.setIntroduction(item.getIntroduction());
        requestDTO.setResult(item.getResult());
        requestDTO.setGovernance(item.getGovernance());
        requestDTO.setQualification(item.getQualification());
        requestDTO.setPopularisation(item.getPopularisation());
        requestDTO.setFight(item.getFight());
        requestDTO.setGenderIssue(item.getGenderIssue());
        requestDTO.setAlternative(item.getAlternative());
        requestDTO.setMass(item.getMass());
        requestDTO.setNote(item.getNote());
        requestDTO.setConclusion(item.getConclusion());
        requestDTO.setCreateDate(item.getCreateDate());
        requestDTO.setSenderUser(UserDTO.parse(item.getSenderUser(),false));
        requestDTO.setAnnualReportStatus(item.getStatus());

        return requestDTO;
    }

    public static List<AnnualReportDTO> parseToList(List<AnnualReport> items) {

        List<AnnualReportDTO> dTOs = new ArrayList<>();
        items.stream().forEach((n) -> {
            dTOs.add(AnnualReportDTO.parse(n));
        });
        return dTOs;
    }

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

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public List<AnnualReportDocumentDTO> getDocuments() {
        return documents;
    }

    public void setDocuments(List<AnnualReportDocumentDTO> documents) {
        this.documents = documents;
    }

    public UserDTO getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(UserDTO senderUser) {
        this.senderUser = senderUser;
    }

    public AnnualReportStatus getAnnualReportStatus() {
        return annualReportStatus;
    }

    public void setAnnualReportStatus(AnnualReportStatus annualReportStatus) {
        this.annualReportStatus = annualReportStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
