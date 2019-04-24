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
@Table(name = "result")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Result.findAll", query = "SELECT e FROM Result e")})
public class Result implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "result_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;


    @Column(name = "championship_id")
    private Integer championshipId;

    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "sportsman_id")
    private Integer sportsmanId;

    @Column(name = "award_id")
    private Integer awardId;


    @Column(name = "note")
    private String note;

    @Column(name = "score")
    private String score;

    @Column(name = "category")
    private String category;

    @Column(name = "create_date")
    @Temporal(TemporalType.DATE)
    private Date createDate;

    @Column(name = "discipline")
    private String discipline;

    public Result() {
    }

    public Result(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getChampionshipId() {
        return championshipId;
    }

    public void setChampionshipId(Integer championshipId) {
        this.championshipId = championshipId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getSportsmanId() {
        return sportsmanId;
    }

    public void setSportsmanId(Integer sportsmanId) {
        this.sportsmanId = sportsmanId;
    }

    public Integer getAwardId() {
        return awardId;
    }

    public void setAwardId(Integer awardId) {
        this.awardId = awardId;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getDiscipline() {
        return discipline;
    }

    public void setDiscipline(String discipline) {
        this.discipline = discipline;
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
        if (!(object instanceof Result)) {
            return false;
        }
        Result other = (Result) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Result[ id=" + id + " ]";
    }

}
