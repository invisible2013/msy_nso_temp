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
 * @author nino
 */
@Entity
@Table(name = "annual_report_document_type")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "AnnualReportDocumentType.findAll", query = "SELECT e FROM AnnualReportDocumentType e")})
public class AnnualReportDocumentType implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Column(name = "id")
    private Integer id;
    @Column(name = "name")
    private String name;


    public AnnualReportDocumentType() {
    }

    public AnnualReportDocumentType(Integer id) {
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



    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AnnualReportDocumentType)) {
            return false;
        }
        AnnualReportDocumentType other = (AnnualReportDocumentType) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "AnnualReportDocumentType[ id=" + id + " ]";
    }

}
