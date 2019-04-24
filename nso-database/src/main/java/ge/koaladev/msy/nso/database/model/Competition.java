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
@Table(name = "competition")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Competition.findAll", query = "SELECT e FROM Competition e")})
public class Competition implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "competition_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;


    @Column(name = "name")
    private String name;

    @Column(name = "location")
    private String location;

    @Column(name = "category")
    private String category;

    @JoinColumn(name = "sender_user_id")
    @OneToOne
    private Users senderUser;

    @JoinColumn(name = "federation_id")
    @OneToOne
    private Users federationUser;

    @Column(name = "create_date")
    @Temporal(TemporalType.DATE)
    private Date createDate;

    @Column(name = "competition_date")
    @Temporal(TemporalType.DATE)
    private Date competitionDate;

    @Column(name = "group_quantity")
    private String groupQuantity;


    @Column(name = "professional")
    private String professional;

    @Column(name = "discipline")
    private String discipline;

    public Competition() {
    }

    public Competition(Integer id) {
        this.id = id;
    }


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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Users getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(Users senderUser) {
        this.senderUser = senderUser;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getCompetitionDate() {
        return competitionDate;
    }

    public void setCompetitionDate(Date competitionDate) {
        this.competitionDate = competitionDate;
    }

    public String getDiscipline() {
        return discipline;
    }

    public void setDiscipline(String discipline) {
        this.discipline = discipline;
    }

    public Users getFederationUser() {
        return federationUser;
    }

    public void setFederationUser(Users federationUser) {
        this.federationUser = federationUser;
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
        if (!(object instanceof Competition)) {
            return false;
        }
        Competition other = (Competition) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Competition[ id=" + id + " ]";
    }

}
