/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.database.model;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;

/**
 *
 * @author mindia
 */
@Entity
@Table(name = "competition_person")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CompetitionPerson.findAll", query = "SELECT e FROM CompetitionPerson e")})
public class CompetitionPerson implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "competition_person_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;

    @JoinColumn(name = "person_id")
    @OneToOne
    private Person person;

    @Column(name = "competition_id")
    private Integer competitionId;


    public CompetitionPerson() {
    }

    public CompetitionPerson(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Integer getCompetitionId() {
        return competitionId;
    }

    public void setCompetitionId(Integer competitionId) {
        this.competitionId = competitionId;
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
        if (!(object instanceof CompetitionPerson)) {
            return false;
        }
        CompetitionPerson other = (CompetitionPerson) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "CompetitionPerson[ id=" + id + " ]";
    }

}
