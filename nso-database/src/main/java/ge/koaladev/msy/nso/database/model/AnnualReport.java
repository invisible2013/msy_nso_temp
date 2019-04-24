/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.database.model;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author nino
 */
@Entity
@Table(name = "annual_report")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "AnnualReport.findAll", query = "SELECT e FROM AnnualReport e")})
public class AnnualReport implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "annual_report_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;


    @Column(name = "year")
    private Integer year;

    @JoinColumn(name = "sender_user_id")
    @OneToOne
    private Users senderUser;

    @JoinColumn(name = "status_id")
    @OneToOne
    private AnnualReportStatus status;

    @Column(name = "introduction")
    private String introduction;

    @Column(name = "result")
    private String result;

    @Column(name = "governance")
    private String governance;

    @Column(name = "qualification")
    private String qualification;

    @Column(name = "popularisation")
    private String popularisation;

    @Column(name = "gender_issue")
    private String genderIssue;

    @Column(name = "fight")
    private String fight;

    @Column(name = "alternative")
    private String alternative;

    @Column(name = "mass")
    private String mass;

    @Column(name = "conclusion")
    private String conclusion;

    @Column(name = "note")
    private String note;

    @Column(name = "create_date")
    @Temporal(TemporalType.DATE)
    private Date createDate;


    public AnnualReport() {
    }

    public AnnualReport(Integer id) {
        this.id = id;
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

    public String getGenderIssue() {
        return genderIssue;
    }

    public void setGenderIssue(String genderIssue) {
        this.genderIssue = genderIssue;
    }

    public String getFight() {
        return fight;
    }

    public void setFight(String fight) {
        this.fight = fight;
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

    public Users getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(Users senderUser) {
        this.senderUser = senderUser;
    }

    public AnnualReportStatus getStatus() {
        return status;
    }

    public void setStatus(AnnualReportStatus status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AnnualReport)) {
            return false;
        }
        AnnualReport other = (AnnualReport) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "AnnualReport[ id=" + id + " ]";
    }

}
