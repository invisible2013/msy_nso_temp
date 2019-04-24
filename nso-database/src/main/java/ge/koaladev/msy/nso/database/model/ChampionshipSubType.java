
package ge.koaladev.msy.nso.database.model;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;

/**
 * @author nl
 */
@Entity
@Table(name = "championship_sub_type")
@XmlRootElement
@NamedQueries({
        @NamedQuery(name = "ChampionshipSubType.findAll", query = "SELECT e FROM ChampionshipSubType e")})
public class ChampionshipSubType implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Column(name = "championship_type_id")
    private Integer championshipTypeId;
    @Column(name = "name")
    private String name;

    public ChampionshipSubType() {
    }

    public ChampionshipSubType(Integer id) {
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

    public Integer getChampionshipTypeId() {
        return championshipTypeId;
    }

    public void setChampionshipTypeId(Integer championshipTypeId) {
        this.championshipTypeId = championshipTypeId;
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
        if (!(object instanceof EventType)) {
            return false;
        }
        ChampionshipSubType other = (ChampionshipSubType) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "ChampionshipSubType[ id=" + id + " ]";
    }

}
