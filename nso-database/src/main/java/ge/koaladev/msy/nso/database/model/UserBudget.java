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
 * @author mindia
 */
@Entity
@Table(name = "user_budget")
@XmlRootElement
@NamedQueries({
        @NamedQuery(name = "UserBudget.findAll", query = "SELECT p FROM UserBudget p")})
public class UserBudget implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "user_budget_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;
    @Column(name = "user_id")
    private Integer userId;
    @JoinColumn(name = "year_id")
    @Column(name = "budget")
    private Double budget;

    public UserBudget() {
    }

    public UserBudget(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
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
        if (!(object instanceof UserBudget)) {
            return false;
        }
        UserBudget other = (UserBudget) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Years[ id=" + id + " ]";
    }

}
